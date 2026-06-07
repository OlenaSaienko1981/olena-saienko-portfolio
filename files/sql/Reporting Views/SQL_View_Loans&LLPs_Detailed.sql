create view V_Loans_LLP_Detailed 
as
select [dbo].[Loans].Customer_ID, [dbo].[Clients].Customer_Name, [dbo].[Clients].Customer_Economic_Sector,
[dbo].[Loans].Orig_Ccy, Ccy_Type 
= case [dbo].[Loans].Orig_Ccy
when 'USD' then 'FX'
when 'EUR' then 'FX'
else 'UAH'
end,
[dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate as Principal_UAH_Amount,
[dbo].[LLPs].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate as LLP_UAH_Amount, 
[dbo].[LLPs].Stage, Loan_Type 
= case [dbo].[LLPs].Stage
when 'stage 1' then 'standard'
when 'stage 2' then 'standard'
else 'NPL'
end,
[dbo].[Loans].Interest_Rate, [dbo].[Loans].Tranche_ID, [dbo].[Loans].Start_Date, [dbo].[Loans].End_Date,
datediff(day, '2020.11.30', [End_Date]) as Remaining_Days, Remaining_Days_Type 
= case
when datediff(day, '2020.11.30', [End_Date]) <= 30 then 'Less than 1 Month'
when datediff(day, '2020.11.30', [End_Date]) > 30 and datediff(day, '2020.11.30', [End_Date]) <= 90 then '1-3 Months'
when datediff(day, '2020.11.30', [End_Date]) > 90 and datediff(day, '2020.11.30', [End_Date]) <= 180 then '3-6 Months'
when datediff(day, '2020.11.30', [End_Date]) > 180 and datediff(day, '2020.11.30', [End_Date]) <= 365 then '6-12 Months'
when datediff(day, '2020.11.30', [End_Date]) > 365 then '1-5 Years'
end,
datediff(day, [End_Date], '2020.11.30') as Overdue_Days, Overdue_Days_Type 
= case
when datediff(day, [End_Date], '2020.11.30') <= 0 then 'No Delay'
when datediff(day, [End_Date], '2020.11.30') > 0 and datediff(day, [End_Date], '2020.11.30') <= 90 then 'Delayed under 90'
when datediff(day, [End_Date], '2020.11.30') > 90 and datediff(day, [End_Date], '2020.11.30') <= 360 
then 'Impaired 90-360'
else 'Impaired over 360'
end,
[dbo].[Loans].Quantity
from [dbo].[Loans]
inner join [dbo].[LLPs]
on [dbo].[LLPs].Tranche_ID = [dbo].[Loans].Tranche_ID
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
inner join [dbo].[Clients]
on [dbo].[Clients].Customer_ID = [dbo].[Loans].Customer_ID;

