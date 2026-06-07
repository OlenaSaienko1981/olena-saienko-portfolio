select [dbo].[Loans].Customer_ID, [dbo].[Clients].[Customer_Name], [dbo].[Loans].Orig_Ccy,
[dbo].[Loans].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate as Principal_UAH_Amount, 
[dbo].[LLPs].Orig_Amount * [dbo].[FX_exch_rates].FX_exch_rate as LLP_UAH_Amount, 
[dbo].[Loans].Interest_Rate, [dbo].[Loans].Tranche_ID, [dbo].[Loans].Start_Date, [dbo].[Loans].End_Date 
from [dbo].[Loans]
inner join [dbo].[LLPs]
on [dbo].[LLPs].Tranche_ID = [dbo].[Loans].Tranche_ID
inner join [dbo].[FX_exch_rates]
on [dbo].[FX_exch_rates].Orig_Ccy = [dbo].[Loans].Orig_Ccy
inner join [dbo].[Clients]
on [dbo].[Clients].Customer_ID = [dbo].[Loans].Customer_ID;