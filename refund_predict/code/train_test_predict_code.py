
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


studentSet=pd.read_csv('C:/Users/leon/Desktop/refund_predict/studentSet_.csv',                      usecols=['Contracts_id','Label','New_cardsex','New_amount','New_paiduprmb','Appointcnt','A','B','C','D','E','F','G','H','I','Clascnt','Diffday','Attended','Class_fee'],                      encoding='GB2312')


# In[3]:


studentSet.info()


# In[30]:


dataSet=studentSet[studentSet['Label']<2]


# In[31]:


dataSet['New_amount']=dataSet['New_amount'].fillna(0)
dataSet['New_paiduprmb']=dataSet['New_paiduprmb'].fillna(0)
dataSet['New_cardsex']=dataSet['New_cardsex'].fillna(99)
dataSet['Appointcnt']=dataSet['Appointcnt'].fillna(90)
dataSet['Class_fee']=dataSet['Class_fee'].fillna(0)


# In[32]:


dataSet.info()


# In[33]:


trainSet=dataSet.iloc[:335613,:]


# In[34]:


testSet=dataSet.iloc[335613:,:]


# In[35]:


trainSet.info()


# In[36]:


testSet.info()


# In[44]:


##构造逻辑回归模型


# In[45]:


from sklearn.linear_model import LogisticRegression


# In[46]:


refund_model=LogisticRegression()


# In[47]:


refund_model.fit(trainSet.iloc[:,2:],trainSet.iloc[:,1])


# In[48]:


refund_model.score(trainSet.iloc[:,2:],trainSet.iloc[:,1])


# In[49]:


##计算精确率召回率


# In[50]:


from sklearn.model_selection import  cross_val_score


# In[51]:


precisions = cross_val_score(refund_model,testSet.iloc[:,2:],testSet.iloc[:,1],                             cv = 5,scoring = 'precision')


# In[52]:


precisions.mean()


# In[53]:


recalls = cross_val_score(refund_model,testSet.iloc[:,2:],testSet.iloc[:,1],                             cv = 5,scoring = 'recall')


# In[54]:


recalls.mean()


# In[55]:


##预测


# In[62]:


predictSet=studentSet[studentSet['Label']==2]


# In[63]:


predictSet['New_amount']=predictSet['New_amount'].fillna(0)
predictSet['New_paiduprmb']=predictSet['New_paiduprmb'].fillna(0)
predictSet['New_cardsex']=predictSet['New_cardsex'].fillna(99)
predictSet['Appointcnt']=predictSet['Appointcnt'].fillna(90)
predictSet['Class_fee']=predictSet['Class_fee'].fillna(0)


# In[64]:


predictSet.info()


# In[65]:


prediction=refund_model.predict(predictSet.iloc[:,2:])


# In[66]:


predictSet['predictLabels']=prediction


# In[74]:


predictSet.head()


# In[72]:


predictSet.to_csv('C:/Users/leon/Desktop/refund_predict/predictSet_result.csv')

