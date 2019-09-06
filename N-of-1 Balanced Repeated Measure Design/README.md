# N-of-1 Balanced Repeated Measure Design
2019.06 - Now
## Basic Information
This folder contains algorithms and trails about n-of-1 balanced repeated measure design. This research project is under supervision of Prof. [Ying Lu](https://steinhardt.nyu.edu/people/ying-lu). The primary focus is to find an algorithm which could produce the shortest sequences that are balanced in terms of first order, second order and etc based on requirements and prove the supremacy in terms of efficiency and accuracy of these sequences compared to random assign treatments when it comes to, for example, finding the best treatment or treatment combination for a certain patient.(e.g, ABBAA is a balanced first order sequence with two treatments (AB), where "AA", "AB", "BA", "BB" all apear once and only once in the sequence, the problem will become more complex when we consider higher orders or more treatments).

## Appendix
[Base line models](https://github.com/Heimine/School_Project/blob/master/Exploring%20techniques%20to%20maximizing%20profit%20using%20dataset%20from%20IBM/Base%20line%20models.ipynb)  
Containing base line models  
[Most of the final results](https://github.com/Heimine/School_Project/blob/master/Exploring%20techniques%20to%20maximizing%20profit%20using%20dataset%20from%20IBM/Most%20of%20the%20final%20results.ipynb)  
Containing all of the results on full feature set and some plots including profit curves under different condtions along with some table illustrates two different feature reduction techniques. Also includes paramter tuning for the feature reduction set on Decition Tree, Logistic Regression and Gradient Boosting.  
[Parameter tuning for feature set after feature reduction and results](https://github.com/Heimine/School_Project/blob/master/Exploring%20techniques%20to%20maximizing%20profit%20using%20dataset%20from%20IBM/Parameter%20tuning%20for%20feature%20set%20after%20feature%20reduction%20and%20results.ipynb)  
Containing paramter tuning for the feature set after reduction by mutual information for Random Forest and resulting ROC curve after parameter tuning.  
[Final Report](https://github.com/Heimine/School_Project/blob/master/Exploring%20techniques%20to%20maximizing%20profit%20using%20dataset%20from%20IBM/DS-GA%201001%20Project%20Report.pdf)  
Containing the final report.

## Note
The sudden drop between base line models and final results regarding the auc score for each classifier is because we didn't delete some features that have problem of leaking and some instances that should not be considered.

(1) The dataset used in this project available at [here](https://www.ibm.com/communities/analytics/watson-analytics-blog/guide-to-sample-datasets/).
