#!/usr/bin/env python3
"""
Requirements:
    pip install nfstream joblib xgboost scikit-learn pandas psutil

Usage:
    sudo python3 ids_it8520.py

Artifacts required (same directory as this script):
    best_model.pkl | scaler.pkl | label_encoder.pkl | selected_features.json
"""

import os
import sys
import json
from datetime import datetime
from collections import Counter

import pandas as pd
import joblib
import psutil
from nfstream import NFStreamer

# =============================================================================
# CONFIGURATION
# =============================================================================

BASE_DIR      = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH    = os.path.join(BASE_DIR, "best_model.pkl")
SCALER_PATH   = os.path.join(BASE_DIR, "scaler.pkl")
ENCODER_PATH  = os.path.join(BASE_DIR, "label_encoder.pkl")
FEATURES_PATH = os.path.join(BASE_DIR, "selected_features.json")

IDLE_TIMEOUT_MS   = 10   # Export flow after 2 s idle
ACTIVE_TIMEOUT_MS = 30  # Force-export after 10 s

# =============================================================================
# LOAD ARTIFACTS
# =============================================================================

def load_artifacts():
    missing = [p for p in [MODEL_PATH, SCALER_PATH, ENCODER_PATH, FEATURES_PATH]
               if not os.path.exists(p)]
    if missing:
        print("[ERROR] Missing files:")
        for p in missing:
            print(f"        {p}")
        sys.exit(1)

    model   = joblib.load(MODEL_PATH)
    scaler  = joblib.load(SCALER_PATH)
    encoder = joblib.load(ENCODER_PATH)
    with open(FEATURES_PATH) as f:
        features = json.load(f)

    return model, scaler, encoder, features

# =============================================================================
# FEATURE EXTRACTION
# =============================================================================

def extract_features(flow, features):
    """Extract the 19 selected NFStream flow features into a DataFrame."""
    row = {}
    for feat in features:
        val = getattr(flow, feat, None)
        if val is None:
            return None   # Skip incomplete flows
        row[feat] = val
    return pd.DataFrame([row], columns=features)

# =============================================================================
# INTERFACE SELECTION
# =============================================================================

def select_interface():
    interfaces = list(psutil.net_if_addrs().keys())
    print("\n--- Available Network Interfaces ---")
    for i, iface in enumerate(interfaces):
        print(f"  [{i}] {iface}")
    try:
        choice = int(input("\nSelect interface index: "))
        return interfaces[choice]
    except (ValueError, IndexError):
        print("[ERROR] Invalid selection.")
        sys.exit(1)

# =============================================================================
# MAIN IDS LOOP
# =============================================================================

def start_ids():
    print("\n[*] Loading artifacts...")
    model, scaler, encoder, features = load_artifacts()
    print(f"[+] Model   : {type(model).__name__}")
    print(f"[+] Scaler  : {type(scaler).__name__}")
    print(f"[+] Classes : {list(encoder.classes_)}")
    print(f"[+] Features: {len(features)}")

    iface = select_interface()
    print(f"\n[!] IDS active on '{iface}' — press Ctrl+C to stop.\n")

    # Print table header
    header = f"{'Time':<12} {'Src IP':<16} {'Dst IP':<16} {'Proto':<6} {'Result':<10} {'Confidence'}"
    print(header)
    print("-" * len(header))

    stats = Counter()

    streamer = NFStreamer(
        source=iface,
        statistical_analysis=True,
        idle_timeout=IDLE_TIMEOUT_MS,
        active_timeout=ACTIVE_TIMEOUT_MS,
    )

    try:
        for flow in streamer:
            print(f"[DEBUG] Got flow: {flow.src_ip} -> {flow.dst_ip}")
            features_scaler = scaler.feature_names_in_.tolist()
            df = extract_features(flow, features_scaler)
            if df is None:
                continue
            
            X_scaled   = scaler.transform(df)
            df_scaled = pd.DataFrame(X_scaled, columns=features_scaler)
            X_final = df_scaled[features]
            pred_idx   = model.predict(X_final)
            label      = encoder.inverse_transform(pred_idx)[0]
            confidence = model.predict_proba(X_scaled).max() * 100

            stats[label] += 1
            ts     = datetime.now().strftime("%H:%M:%S")
            result = "[ATTACK]" if label == "attack" else "[ OK   ]"
            print(label)
            print(
                f"{ts:<12} {flow.src_ip:<16} {flow.dst_ip:<16} "
                f"{flow.protocol:<6} {result:<10} {confidence:.1f}%"
            )

    except KeyboardInterrupt:
        print(f"\n[!] IDS stopped.")
        print(f"    Flows classified : {sum(stats.values())}")
        print(f"    Normal           : {stats['normal']}")
        print(f"    Attack           : {stats['attack']}")


if __name__ == "__main__":
    start_ids()