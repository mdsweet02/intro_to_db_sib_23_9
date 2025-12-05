CREATE OR ALTER VIEW V_MeltImpurities
AS
SELECT 
    mi.MeltID,
    e.ElementName,
    mi.Amount AS ImpurityAmount
FROM MeltImpurities mi
JOIN ChemicalElements e ON mi.ElementID = e.ElementID;
GO