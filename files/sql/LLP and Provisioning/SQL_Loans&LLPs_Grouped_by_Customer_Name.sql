select [dbo].[Clients].Customer_Name, sum([dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate)
as Total_Principal_UAH_Amount, sum([dbo].[LLPs].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate)
as Total_LLP_UAH_Amount 
from [dbo].[Loans]
inner join [dbo].[LLPs]
on [dbo].[LLPs].Tranche_ID = [dbo].[Loans].Tranche_ID
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
inner join [dbo].[Clients]
on [dbo].[Clients].Customer_ID = [dbo].[Loans].Customer_ID
group by [dbo].[Clients].Customer_Name;