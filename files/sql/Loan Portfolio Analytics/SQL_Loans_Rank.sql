select [dbo].[Clients].Customer_Name, sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate) as UAH_Amount,
rank() over (order by sum([dbo].[Loans].[Orig_Amount] * [dbo].[FX_exch_rates].[FX_exch_rate]) desc) as Rank
from [dbo].[Loans]
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
inner join [dbo].[Clients]
on [dbo].[Clients].Customer_ID = [dbo].[Loans].Customer_ID
group by [dbo].[Clients].Customer_Name;