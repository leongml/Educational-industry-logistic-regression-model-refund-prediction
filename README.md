# -逻辑回归模型预测教育行业退费人群
选取学员的相应特征，运用机器学习的逻辑回归模型，对在读执行中学员进行预测是否退费，从而防范于未然。

场景说明：选取学员的相应特征，运用机器学习的逻辑回归模型，对在读执行中学员进行预测是否退费，从而防范于未然。（实际上做着玩玩儿...并没什么实际运用）

使用工具：Python 3，Jupyter Notebook。

数据说明：以下数据均使用真实数据，数据均已脱敏。

特征选取：（借鉴教育行业老前辈所推荐的特征...因此省了不少时间）

字段名	说明

Contracts_id	合同号


Label	预测标签(1:正常，0:退费，2:执行中)


New_cardsex	性别

New_amount	合同级别

New_paiduprmb	合同价格

Appointcnt	预约次数

A	渠道交互-A

B	渠道交互-B

C	渠道交互-C

D	渠道交互-D

E	渠道交互-E

F	渠道交互-F

G	渠道交互-G

H	渠道交互-H

I	渠道交互-I

Clascnt	教学-上课次数

Diffday	教学-上课时间

Attended	教学-上课出席

Class_fee	教学-课消费用

步骤及代码：

##加载包及数据集

import pandas as pd 
 
studentSet=pd.read_csv('C:/Users/leon/Desktop/refund_predict/studentSet_.csv',\
 
                      usecols=['Contracts_id','Label','New_cardsex','New_amount','New_paiduprmb','Appointcnt','A','B','C','D','E','F','G','H','I','Clascnt','Diffday','Attended','Class_fee'],\
                      
                      encoding='GB2312')
                      
studentSet.info()

<class 'pandas.core.frame.DataFrame'>

RangeIndex: 518610 entries, 0 to 518609

Data columns (total 19 columns):

Contracts_id     518610 non-null int64

Label            518610 non-null int64

New_cardsex      518610 non-null int64

New_amount       511013 non-null float64

New_paiduprmb    518543 non-null float64

Appointcnt       518610 non-null int64

A                518610 non-null int64

B                518610 non-null int64

C                518610 non-null int64

D                518610 non-null int64

E                518610 non-null int64

F                518610 non-null int64

G                518610 non-null int64

H                518610 non-null int64

I                518610 non-null int64

Clascnt          518610 non-null int64

Diffday          518610 non-null int64

Attended         518610 non-null int64

Class_fee        518543 non-null float64

dtypes: float64(3), int64(16)

memory usage: 75.2 MB

##构造训练集&测试集

dataSet=studentSet[studentSet['Label']<2] #选取退费（0）&毕业（1）学员数据


dataSet['New_amount']=dataSet['New_amount'].fillna(0)

dataSet['New_paiduprmb']=dataSet['New_paiduprmb'].fillna(0)

dataSet['New_cardsex']=dataSet['New_cardsex'].fillna(99)

dataSet['Appointcnt']=dataSet['Appointcnt'].fillna(0)

dataSet['Class_fee']=dataSet['Class_fee'].fillna(0) #缺失值处理


dataSet.info()

<class 'pandas.core.frame.DataFrame'>

Int64Index: 447485 entries, 0 to 518550

Data columns (total 19 columns):

Contracts_id     447485 non-null int64

Label            447485 non-null int64

New_cardsex      447485 non-null int64

New_amount       447485 non-null float64

New_paiduprmb    447485 non-null float64

Appointcnt       447485 non-null int64

A                447485 non-null int64

B                447485 non-null int64

C                447485 non-null int64

D                447485 non-null int64

E                447485 non-null int64

F                447485 non-null int64

G                447485 non-null int64

H                447485 non-null int64

I                447485 non-null int64

Clascnt          447485 non-null int64

Diffday          447485 non-null int64

Attended         447485 non-null int64

Class_fee        447485 non-null float64

dtypes: float64(3), int64(16)

memory usage: 68.3 MB

trainSet=dataSet.iloc[:335613,:]

testSet=dataSet.iloc[335614:,:] #选取前3/4作为训练集，后1/4作为测试集


##构造逻辑回归模型


from sklearn.linear_model import LogisticRegression #加载逻辑回归模型

refund_model=LogisticRegression() #构造模型

refund_model.fit(trainSet.iloc[:,2:],trainSet.iloc[:,1]) #模型训练

Out :

LogisticRegression(C=1.0, class_weight=None, dual=False, fit_intercept=True,
          intercept_scaling=1, max_iter=100, multi_class='ovr', n_jobs=1,
          penalty='l2', random_state=None, solver='liblinear', tol=0.0001,
          verbose=0, warm_start=False)
          
          
 refund_model.score(trainSet.iloc[:,2:],trainSet.iloc[:,1]) #查看模型评分
 
Out :
0.97342474814741975


##计算测试集精确率召回率

from sklearn.model_selection import  cross_val_score

precisions = cross_val_score(refund_model,testSet.iloc[:,2:],testSet.iloc[:,1],\

                             cv = 5,scoring = 'precision')
                             
precisions.mean() #查看计算精确率

Out :
0.89401980382671342

​
recalls = cross_val_score(refund_model,testSet.iloc[:,2:],testSet.iloc[:,1],\

                             cv = 5,scoring = 'recall')
                             
recalls.mean() #查看计算召回率

Out :
0.9492788504827947

##预测在读执行中学员是否退费

predictSet=studentSet[studentSet['Label']==2] #2代表执行中在读学员

​
predictSet['New_amount']=predictSet['New_amount'].fillna(0)

predictSet['New_paiduprmb']=predictSet['New_paiduprmb'].fillna(0)

predictSet['New_cardsex']=predictSet['New_cardsex'].fillna(99)

predictSet['Appointcnt']=predictSet['Appointcnt'].fillna(0)

predictSet['Class_fee']=predictSet['Class_fee'].fillna(0) #处理缺失值

​

predictSet.info()

<class 'pandas.core.frame.DataFrame'>

Int64Index: 60037 entries, 415 to 518607

Data columns (total 19 columns):

Contracts_id     60037 non-null int64

Label            60037 non-null int64

New_cardsex      60037 non-null int64

New_amount       60037 non-null float64

New_paiduprmb    60037 non-null float64

Appointcnt       60037 non-null int64

A                60037 non-null int64

B                60037 non-null int64

C                60037 non-null int64

D                60037 non-null int64

E                60037 non-null int64

F                60037 non-null int64

G                60037 non-null int64

H                60037 non-null int64

I                60037 non-null int64

Clascnt          60037 non-null int64

Diffday          60037 non-null int64

Attended         60037 non-null int64

Class_fee        60037 non-null float64

dtypes: float64(3), int64(16)

memory usage: 9.2 MB

prediction=refund_model.predict(predictSet.iloc[:,2:]) #预测数据导入到模型当中

predictSet['predictLabels']=prediction #将预测结果输出到数据集

predictSet.head()


##输出数据样式

Contracts_id代表该学员的合同ID，可关联到学员的相关信息；

红色框predictLabels代表预测结果，0代表退费，1代表不会退费；

predictSet.to_csv('C:/Users/leon/Desktop/refund_predict/predictSet_result.csv')

将数据输出出来，最后进行可视化操作或根据名单跟进退费学员，增强服务以避免退费。

就酱紫...结束!

以上有需提升之处，望大佬能够指出以便改正，少走弯路。


