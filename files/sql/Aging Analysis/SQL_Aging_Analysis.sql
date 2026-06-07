select [Overdue_Days_Type], count(distinct [Customer_ID]) as Number_of_Customers, 
sum([Principal_UAH_Amount]) as Gross_Loans
from [dbo].[V_Loans_LLP_Detailed]
group by [Overdue_Days_Type];

