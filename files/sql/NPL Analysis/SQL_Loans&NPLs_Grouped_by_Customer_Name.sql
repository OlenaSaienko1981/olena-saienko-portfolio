select [Customer_Name], sum([Principal_UAH_Amount]) as Gross_Loans, sum(case when [Loan_Type] = 'NPL' then 
[Principal_UAH_Amount] end) as Gross_NPL, sum([LLP_UAH_Amount]) as Provisions 
from [dbo].[V_Loans_LLP_Detailed]
group by [Customer_Name];