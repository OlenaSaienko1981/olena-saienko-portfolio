select [dbo].[Clients].Customer_Name, [dbo].[Loans].Orig_Ccy, 
sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as UAH_Amount, 
avg([dbo].[Loans].Interest_Rate) as Avg_Interest_Rate
from [dbo].[Loans]
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
inner join [dbo].[Clients]
on [dbo].[Clients].Customer_ID = [dbo].[Loans].Customer_ID
group by [dbo].[Clients].Customer_Name, [dbo].[Loans].Orig_Ccy
order by [dbo].[Clients].Customer_Name;
