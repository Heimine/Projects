# Exploring techniques to maximizing profit using dataset from IBM
2018.11 - 2018.12
## Basic Information
This project was a term group project for Introduction to Data Science (DS-GA 1001) with [Alex Spence](https://github.com/aspen8400) and Jonas Bartl. The idea of the project is using historical dataset from IBM (1) including 78025 sales opportunity with features like opportunity amount, route to market, region of opportunity and the result of each opportunity identified as win or loss to find the best model which could offer the best profit by making some assumptions about the company.

## Personal Contribution
Did data preprocessing and implemented base line models including Decition Tree, Logistic Regression and Support Vector Machine;
Implemented feature reduction by Decision Tree feature importances and mutual information;
Implemented Gradient Boosting classifier and did parameter tuning for it;
Made profit curves for each classifiers by using some assumption about the company.

## Appendix
[Base line models]  
(https://github.com/Heimine/School_Project/blob/master/Exploring%20techniques%20to%20maximizing%20profit%20using%20dataset%20from%20IBM/Base%20line%20models.ipynb)  
Containing base line models
[Most of the final results](https://github.com/Heimine/School_Project/blob/master/Exploring%20techniques%20to%20maximizing%20profit%20using%20dataset%20from%20IBM/Most%20of%20the%20final%20results.ipynb)
Containing all of the results on full feature set and some plots including profit curves under different condtions along with some table illustrates two different feature reduction techniques. Also includes paramter tuning for the feature reduction set on Decition Tree, Logistic Regression and Gradient Boosting.
[Parameter tuning for feature set after feature reduction and results](https://github.com/Heimine/School_Project/blob/master/Exploring%20techniques%20to%20maximizing%20profit%20using%20dataset%20from%20IBM/Parameter%20tuning%20for%20feature%20set%20after%20feature%20reduction%20and%20results.ipynb)
Containing paramter tuning for the feature set after reduction by mutual information for Random Forest and resulting ROC curve after parameter tuning.

## Note
The sudden drop between base line models and final results regarding the auc score for each classifier is because we didn't delete some features that have problem of leaking and some instances that should not be considered.
