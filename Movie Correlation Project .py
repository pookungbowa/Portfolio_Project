#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# Research question: What factors influence gross earnings of a movie?
# Hypothesis_1: There will be a correlation between the budget and gross earnings 
# Null_Hypothesis_1: There will not be a correlation between the budget and gross earnings
# Hypothesis_2: There may be a correlation between company and gross earnings 
# Null_Hypothesis_2: There will not be a correlation between company name and gross earnings


# In[7]:


# Imported the libraries needed to complete analysis

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

# Dataset is uploaded 
df = pd.read_csv('~/Documents/Projects/movies.csv')


# In[4]:


# Glimpse of the imported data 

df.head()


# In[9]:


# Utilized to check for missing data 

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[10]:


# Utilized to identify data types wtihin each column

df.dtypes


# In[28]:


# Sort data

df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[27]:


pd.set_option('display.max_rows', None)


# In[29]:


# Utilized to drop any existing duplicates, resulting in displaying distinct values

df['company'].drop_duplicates().sort_values(ascending=False)


# In[30]:


df


# In[32]:


# scatterplot to visualize budget vs gross revenue 

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')
plt.xlabel('Gross Earnings')
plt.ylabel('Film Budget')
plt.show()


# In[36]:


# Utilized seaborn to plot earnings and film budget. The visual shows a positive correlation

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color": "blue"}, line_kws={"color":"red"})


# In[37]:


# Analysis of correlation. The correlation values between budget and gross are closest in value.
# there are three correlation types: pearson(default), kendall, and spearman
df.corr(method='pearson')


# In[ ]:


# conclusion: Data analysis shows that there is indeed a correlation between gross earnings and budget 
# Hypothesis_1: There will be a correlation between the budget and gross earnings = True
# Null_Hypothesis_1: There will not be a correlation between the budget and gross earnings = False


# In[39]:


# Additional visualization utilizing correlation matrix 
correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix For Numeric Values')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')

plt.show()


# In[40]:


# Phase 2: Analyze correlation between company andn gross earnings 
df.head()


# In[41]:


# numerize object data into numbers
df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized


# In[42]:


# Visualize data utilizing correlation matrix

correlation_matrix = df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix For Numeric Values')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')

plt.show()


# In[44]:


df_numerized.corr()


# In[45]:


# unstacking data for efficinet analysis

correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[46]:


# Arranging data for efficient analysis

sorted_pairs = corr_pairs.sort_values() 
sorted_pairs


# In[47]:


# votes and budget have highest correlation to gross earnings
# company has low correlation, hypothesis regarding company was wrong
high_corr = sorted_pairs[(sorted_pairs) > 0.5]
high_corr


# In[ ]:


# Conclusion: Votes and budget have highest correlation to gross earnings 
# Hypothesis_2: There may be a correlation between company and gross earnings = False 
# Null_Hypothesis_2: There will not be a correlation between company name and gross earnings = True 

