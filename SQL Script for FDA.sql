USE db_kaggle;

#Task 1: Q1
SELECT 
    EXTRACT(YEAR FROM ActionDate) AS ap_year,
    COUNT(ApplNo) AS count_approved
FROM
    db_kaggle.regactiondate
WHERE
    ActionType = 'AP'
GROUP BY ap_year
ORDER BY ap_year;  # Most drugs approved after 1975

#Q2
SELECT 
    ap_year,
    count_approved
FROM
    (SELECT 
        EXTRACT(YEAR FROM ActionDate) AS ap_year,
        COUNT(ApplNo) AS count_approved,
        RANK() OVER (ORDER BY COUNT(ActionType) DESC) AS approval_rank
    FROM
        db_kaggle.regactiondate
    WHERE
        ActionType = 'AP'
    GROUP BY ap_year) AS yearly_approvals
WHERE
    approval_rank <= 3; #2002,2000,2001 have highest approved drugs
    
SELECT 
    ap_year,
    count_approved
FROM
    (SELECT 
        EXTRACT(YEAR FROM ActionDate) AS ap_year,
        COUNT(ApplNo) AS count_approved,
        RANK() OVER (ORDER BY COUNT(ActionType)) AS approval_rank
    FROM
        db_kaggle.regactiondate
    WHERE
        ActionType = 'AP'
    GROUP BY ap_year) AS yearly_approvals
WHERE
    approval_rank <= 4; #1945, 1943, 1944 have Lowest approved drugs
    
#Q3

SELECT 
    application.SponsorApplicant,
    EXTRACT(YEAR FROM regactiondate.ActionDate) AS ap_year,
    COUNT(application.ApplNo) AS count_approved
FROM
    db_kaggle.application
        JOIN
    db_kaggle.regactiondate ON application.ApplNo = regactiondate.ApplNo
WHERE
    application.ActionType = 'AP'
GROUP BY 1 , 2
ORDER BY 3 DESC;

#Q4
SELECT 
    application.SponsorApplicant,
    EXTRACT(YEAR FROM regactiondate.ActionDate) AS ap_year,
    COUNT(application.ApplNo) AS count_approved,
    rank() over(PARTITION BY EXTRACT(YEAR FROM regactiondate.ActionDate) order by COUNT(application.ApplNo) desc) as ap_rank
FROM
    db_kaggle.application
        JOIN
    db_kaggle.regactiondate ON application.ApplNo = regactiondate.ApplNo
WHERE
    application.ActionType = 'AP'
        AND EXTRACT(YEAR FROM regactiondate.ActionDate) BETWEEN 1939 AND 1960
GROUP BY 1, 2
ORDER BY 3 DESC;

#Task 2: Q1

SELECT 
    ProductMktStatus,
    COUNT(ApplNo) AS total_no_of_drugs_by_mkt_status
FROM
    db_kaggle.product
GROUP BY 1; #Most drug marketed under 1 status
 
 #Q2
 
 SELECT 
    product.ProductMktStatus,
    EXTRACT(YEAR FROM regactiondate.ActionDate) AS ap_year,
    COUNT(product.ApplNo) AS total_no_of_drugs_by_mkt_status
FROM
    db_kaggle.product
        JOIN
    db_kaggle.regactiondate ON product.ApplNo = regactiondate.ApplNo
GROUP BY 1 , 2
ORDER BY 1;

 #Q3

SELECT
	ProductMktStatus,
	EXTRACT(YEAR FROM regactiondate.ActionDate) AS ap_year,
	COUNT(product.ApplNo) AS total_no_of_drugs,
	RANK() OVER (ORDER BY COUNT(product.ApplNo) DESC) AS status_rank
FROM
	db_kaggle.product
JOIN
	db_kaggle.regactiondate ON product.ApplNo = regactiondate.ApplNo
GROUP BY
	ProductMktStatus, ap_year; ##Most drug marketed under 1 status in year 2002

#Task 3: Q1
SELECT 
    Form,
    COUNT(ApplNo) AS total_no_of_drugs_by_mkt_status
FROM
    db_kaggle.product
GROUP BY 1
Order BY 2 DESC; #Most drugs are Form of tabletOral

#Q2
SELECT 
    product.Form,
    COUNT(product.ApplNo) AS count_approved
FROM
    db_kaggle.product
        JOIN
    db_kaggle.application ON product.ApplNo = application.ApplNo
WHERE
    application.ActionType = 'AP'
GROUP BY 1
ORDER BY 2 DESC; #Most drugs are Form of tabletOral

#Q3
SELECT 
    product.Form,
    EXTRACT(YEAR FROM regactiondate.ActionDate) AS ap_year,
    COUNT(product.ApplNo) AS count_approved
FROM
    db_kaggle.product
        JOIN
    db_kaggle.regactiondate ON product.ApplNo = regactiondate.ApplNo
WHERE
    regactiondate.ActionType = 'AP'
GROUP BY 1, 2
ORDER BY 3 DESC; #Most approved drugs are Form of tabletOral in year 2002

#Task 4: Q1
SELECT 
    product_tecode.TECode,
    COUNT(product_tecode.ApplNo) AS count_approved
FROM
    db_kaggle.product_tecode
        JOIN
    db_kaggle.regactiondate ON product_tecode.ApplNo = regactiondate.ApplNo
WHERE
    regactiondate.ActionType = 'AP'
GROUP BY 1
ORDER BY 2 DESC; #Most approved drugs are with AB TEcode

#Q2
SELECT 
    product_tecode.TECode,
    EXTRACT(YEAR FROM regactiondate.ActionDate) AS ap_year,
    COUNT(product_tecode.ApplNo) AS count_approved
FROM
    db_kaggle.product_tecode
        JOIN
    db_kaggle.regactiondate ON product_tecode.ApplNo = regactiondate.ApplNo
WHERE
    regactiondate.ActionType = 'AP'
GROUP BY 1, 2
ORDER BY 3 DESC;#Most approved drugs are with AB TEcode in year 1996
