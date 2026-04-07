Overall Hiring Rate
SELECT
    COUNT(*) AS Total_Applicants,
    SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) AS Total_offered,
    ROUND(
        SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS offered_Rate_Pct
FROM recruitment_data;

Hiring Rate by Job Title
SELECT
    `Job Title`,
    COUNT(*) AS Total_Applicants,
    SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) AS Total_Hired,
    ROUND(
        SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Hiring_Rate_Pct
FROM recruitment_data
GROUP BY `Job Title`
ORDER BY Hiring_Rate_Pct DESC;

Average Time to Hire by Job Title
SELECT
    `Job Title`,
    COUNT(*) AS Total_Hired,
    ROUND(
        AVG(
            JULIANDAY(`Hire Date`) - JULIANDAY(`Application Date`)
        ), 1
    ) AS Avg_Days_To_Hire
FROM recruitment_data
WHERE `Status` = 'Offered'
    AND `Hire Date` != ''
GROUP BY `Job Title`
ORDER BY Avg_Days_To_Hire DESC;

Source Effectiveness
SELECT
    Source,
    COUNT(*) AS Total_Applicants,
    SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) AS Total_Hired,
    ROUND(
        SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Conversion_Rate_Pct
FROM recruitment_data
GROUP BY Source
ORDER BY Conversion_Rate_Pct DESC;

ADVANCED! Hiring Rank by Source using Window Functions
SELECT
    Source,
    `Job Title`,
    COUNT(*) AS Total_Applicants,
    SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) AS Total_Hired,
    ROUND(
        SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Conversion_Rate_Pct,
    RANK() OVER (
        PARTITION BY Source
        ORDER BY
            SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) * 100.0
            / COUNT(*) DESC
    ) AS Rank_Within_Source
FROM recruitment_data
GROUP BY Source, `Job Title`
ORDER BY Source, Rank_Within_Source;

ADVANCED! Experience vs Hiring Success
SELECT
    CASE
        WHEN `Years of Experience` < 2  THEN '0-2 Years'
        WHEN `Years of Experience` < 5  THEN '2-5 Years'
        WHEN `Years of Experience` < 10 THEN '5-10 Years'
        ELSE '10+ Years'
    END AS Experience_Band,
    COUNT(*) AS Total_Applicants,
    SUM(CASE WHEN `Status` = '`offered`' THEN 1 ELSE 0 END) AS Total_Hired,
    ROUND(
        SUM(CASE WHEN `Status` = 'Offered' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Hiring_Rate_Pct
FROM recruitment_data
GROUP BY Experience_Band
ORDER BY Hiring_Rate_Pct DESC;