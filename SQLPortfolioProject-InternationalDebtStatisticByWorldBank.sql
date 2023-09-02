--1.The World Bank's international debt data
SELECT *
FROM PortfolioProject..IDSCountry

SELECT *
FROM PortfolioProject..IDSData

--2. Finding the number of distinct countries

SELECT DISTINCT idd.Country_Name AS Country_Name
FROM PortfolioProject..IDSCountry AS idc
JOIN PortfolioProject..IDSData AS idd
ON idc.Country_Code = idd.Country_Code
WHERE Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
ORDER BY Country_Name


SELECT COUNT (DISTINCT Country_Name) AS TotalDistinctCountry
FROM PortfolioProject..IDSCountry AS idc
JOIN PortfolioProject..IDSData AS idd
ON idc.Country_Code = idd.Country_Code
WHERE Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'


-- 122 countries

--3. Finding out the distinct debt indicators

SELECT DISTINCT Indicator_Name, Indicator_Code
FROM PortfolioProject..IDSData
ORDER BY 1

SELECT DISTINCT Indicator_Name, Indicator_Code
FROM PortfolioProject..IDSData
WHERE Indicator_Name LIKE '%US$%' AND (Indicator_Name LIKE '%debt%' OR Indicator_Name LIKE '%IMF%')
ORDER BY 1

--4. Totaling the amount of debt owed by the countries

SELECT *
FROM PortfolioProject..IDSData
ORDER BY 3

SELECT Country_Name, Indicator_Name, CONVERT(FLOAT,Year_2016) AS DebtYear2016
FROM PortfolioProject..IDSData
WHERE Indicator_Name LIKE 'External debt stocks, total (DOD, current US$)' AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
ORDER BY 3 DESC


SELECT Country_Name, SUM(CONVERT(FLOAT,Year_2016)) AS DebtYear2016
FROM PortfolioProject..IDSData
WHERE (Indicator_Name LIKE 'External debt stocks, long-term (DOD, current US$)' OR Indicator_Name LIKE 'External debt stocks, short-term (DOD, current US$)' OR Indicator_Name LIKE 'Use of IMF credit%') AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
GROUP BY Country_Name
ORDER BY 2 DESC


--5. Country with the highest debt

SELECT Country_Name, CONVERT(FLOAT,Year_2016) AS MaxDebtYear2016
FROM PortfolioProject..IDSData
WHERE Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
AND CONVERT(FLOAT,Year_2016) = 
	(SELECT MAX(CONVERT(FLOAT,Year_2016))
	FROM PortfolioProject..IDSData
	WHERE Indicator_Name LIKE 'External debt stocks, total (DOD, current US$)' AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%')

	--conclusion: china that have the highest debt

--6. Average amount of debt across indicators

SELECT Indicator_Name, AVG (CONVERT(FLOAT,Year_2016)) AS AverageDebt2016
FROM PortfolioProject..IDSData
WHERE Indicator_Name LIKE '%US$%' AND (Indicator_Name LIKE '%debt%' OR Indicator_Name LIKE '%IMF%') AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
GROUP BY Indicator_Name
ORDER BY 2 DESC

--7. The highest amount of principal repayments

SELECT Country_Name, Indicator_Name, CONVERT(FLOAT,Year_2016) AS PrincipalRepayments
FROM PortfolioProject..IDSData
WHERE Indicator_Name LIKE 'Principal repayments on external debt, long-term + IMF (AMT, current US$)' AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
AND CONVERT(FLOAT,Year_2016) = 
	(SELECT MAX(CONVERT(FLOAT,Year_2016))
	FROM PortfolioProject..IDSData
	WHERE Indicator_Name LIKE 'Principal repayments on external debt, long-term + IMF (AMT, current US$)' AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%')

-- Brazil have the highest principal repayment(external debt, long term + IMF)

SELECT Country_Name, Indicator_Name, CONVERT(FLOAT,Year_2023) AS PrincipalRepayments
FROM PortfolioProject..IDSData
WHERE Indicator_Name LIKE 'Principal repayments on external debt, long-term (AMT, current US$)' AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
AND CONVERT(FLOAT,Year_2016) = 
	(SELECT MAX(CONVERT(FLOAT,Year_2016))
	FROM PortfolioProject..IDSData
	WHERE Indicator_Name LIKE 'Principal repayments on external debt, long-term (AMT, current US$)' AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%')

-- year_2023, Brazil have the highest principal repayment(external debt,long term)

--8. The most common debt indicator

SELECT Indicator_Name, COUNT (CONVERT(FLOAT,Year_2023)) AS CountDebt
FROM PortfolioProject..IDSData
WHERE Indicator_Name LIKE '%US$%' AND (Indicator_Name LIKE '%debt%' OR Indicator_Name LIKE '%IMF%') AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
GROUP BY Indicator_Name
ORDER BY 2 DESC

--year 2023, most common debt is principal repayment.
----------------
--9. Other viable debt issues and conclusion

--conclusion: 


--Summary external debt data by debtor type, there are Use of IMF credit, long and short term debt, long term of private sector and public sector also long term of guarantee and nonguaranteed.

--Summary external debt stock by creditor type:
--amount of debt for each country=

SELECT Country_Name, Indicator_Name, CONVERT(FLOAT,Year_2016) AS DebtYear2016
FROM PortfolioProject..IDSData
WHERE Indicator_Name LIKE 'Debt service on external debt, total (TDS, current US$)' AND Country_Name NOT LIKE '%income%' AND Country_Name NOT LIKE '%countries%' AND Country_Name NOT LIKE 'IDA%' AND Country_Name NOT LIKE 'South Asia' AND Country_Name NOT LIKE 'Central African%'
ORDER BY 3 DESC

--china have both highest debt: by debtor type and by creditor type