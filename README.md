# AI Network Intrusion Detection Project

An AI-powered network intrusion detection system that classifies network traffic as normal or attack using advanced machine learning techniques and network flow analysis.

## Overview
This project implements a comprehensive network intrusion detection system (NIDS) that leverages machine learning to identify and classify malicious network traffic. It uses NFStream for network flow data collection and employs multiple classification algorithms to detect potential network attacks with high accuracy.

## Project Description
This system analyzes network traffic flows and applies machine learning models to distinguish between normal traffic and potential security threats. The project combines network data analysis with advanced ML techniques to provide robust intrusion detection capabilities.

## Technologies & Tools
- **Network Analysis**: NFStream
- **Machine Learning Frameworks**: scikit-learn, XGBoost
- **Data Processing**: Python, Pandas, NumPy
- **Development**: Jupyter Notebook

## Language Composition
- **Jupyter Notebook**: 97.3%
- **PowerShell**: 1.4%
- **Python**: 1.3%

## Machine Learning Models
The project implements and compares multiple classification algorithms:
- **Random Forest** - Ensemble learning approach
- **XGBoost** - Gradient boosting method
- **Support Vector Machine (SVM)** - Kernel-based classification
- **Logistic Regression** - Linear classification model
- **K-Nearest Neighbors (KNN)** - Instance-based learning

## Key Features
- **NFStream Integration** - Extract and analyze network flow data
- **Feature Engineering** - Advanced feature extraction and selection
- **Class Balancing** - SMOTE (Synthetic Minority Over-sampling Technique) for handling imbalanced datasets
- **Model Comparison** - Comprehensive performance metrics across all algorithms
- **Attack Classification** - Binary classification (Normal vs Attack traffic)
- **Performance Analysis** - Detailed evaluation and comparison of model effectiveness

## Data Processing Pipeline
1. **Data Collection** - Network traffic captured via NFStream
2. **Feature Engineering** - Extract relevant features from network flows
3. **Data Balancing** - Apply SMOTE to balance attack and normal traffic samples
4. **Model Training** - Train multiple ML algorithms on processed data
5. **Performance Evaluation** - Compare models using relevant metrics
6. **Classification** - Deploy best-performing model for real-time detection

## Project Structure
- Jupyter Notebooks containing the complete analysis pipeline
- Data preprocessing and feature engineering scripts
- Model training and evaluation notebooks
- Performance comparison analysis
- PowerShell scripts for system integration

## Getting Started

### Prerequisites
- Python 3.7+
- Jupyter Notebook
- Required Python packages:
  - NFStream
  - scikit-learn
  - XGBoost
  - Pandas
  - NumPy
  - imbalanced-learn (for SMOTE)

### Installation
```bash
pip install nfstream scikit-learn xgboost pandas numpy imbalanced-learn jupyter
```

### Usage
1. Start Jupyter Notebook:
   ```bash
   jupyter notebook
   ```
2. Open the project notebooks
3. Follow the analysis pipeline from data collection to model comparison
4. Review performance metrics and classification results

## Model Evaluation Metrics
- **Accuracy** - Overall correctness of predictions
- **Precision** - True positive rate among predicted attacks
- **Recall** - Detection rate of actual attacks
- **F1-Score** - Harmonic mean of precision and recall
- **ROC-AUC** - Model discrimination capability
- **Confusion Matrix** - Breakdown of prediction types

## Key Insights
The project provides:
- Comparative analysis of different ML algorithms for intrusion detection
- Impact of feature engineering on model performance
- Benefits of SMOTE in handling imbalanced security datasets
- Recommendations for production deployment

## Performance Comparison
Each model is evaluated on the same dataset with SMOTE balancing applied, ensuring fair comparison across all algorithms.

## Applications
- Network security monitoring
- Cyber threat detection
- Real-time traffic classification
- Security incident response
- Network anomaly detection

## Author
Boyaf3

## License
[Add your license information here]

## References
- NFStream Documentation
- scikit-learn Machine Learning Library
- XGBoost Documentation
- SMOTE Research Papers
