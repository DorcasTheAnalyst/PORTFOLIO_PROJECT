
-----DATA CLEANING IN SQL---------------


SELECT *
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing


---The above query is to pullout and preview what the dataset looks like and to know what to correct from it.




----CHANGING THE DATE FORMAT--------------

SELECT SaleDate 
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD NewSaleDate Date;

UPDATE NashvilleHousing
SET NewSaleDate = CONVERT(Date, SaleDate)

SELECT NewSaleDate
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing 

----The last query shows the sale date has been corrected..



------- POPULATE PROPERTY ADDRESS--------
SELECT PropertyAddress
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT  a.ParcelId, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing a
JOIN PORTFOLIO_PROJECT.dbo.NashvilleHousing b
   ON a.ParcelID = b.ParcelID 
   AND a.[UniqueID ] <> b.[UniqueID ]
   WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing a
JOIN PORTFOLIO_PROJECT.dbo.NashvilleHousing b
   ON a.ParcelID = b.ParcelID 
   AND a.[UniqueID ] <> b.[UniqueID ]
   WHERE a.PropertyAddress IS NULL



 -------Breaking Out PropertyAddress Column into Individual Columns (Address, City, State)------------

SELECT PropertyAddress
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS City
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD SplitPropertyAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET SplitPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
ADD SplitPropertyCity  NVARCHAR(255);

UPDATE NashvilleHousing
SET SplitPropertyCity =   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) 

SELECT *
FROM PORTFOLIO_PROJECT. dbo.NashvilleHousing

----- Working on the Owner Address column----------

SELECT OwnerAddress
FROM PORTFOLIO_PROJECT. dbo.NashvilleHousing

SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
 FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing


  ALTER TABLE NashvilleHousing
  ADD SplitOwnerAddress NVARCHAR(255);

  UPDATE NashvilleHousing
  SET SplitOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

  ALTER TABLE NashvilleHousing
  ADD SplitOwnerCity NVARCHAR(255);

  UPDATE NashvilleHousing
  SET SplitOwnerCity= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

  ALTER TABLE NashvilleHousing
  ADD SplitOwnerState NVARCHAR(255);

  UPDATE NashvilleHousing
  SET SplitOwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

  SELECT *
  FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing


  ----------Change  Y and N to YES and NO in "Sold As vacant" Field------------

  SELECT (SoldAsVacant), COUNT(SoldAsVacant) 
  FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing
  GROUP BY SoldAsVacant
  ORDER BY 2


  SELECT SoldAsVacant
  , CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
         WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
         WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
		

SELECT *
FROM PORTFOLIO_PROJECT. dbo.NashvilleHousing


------Remove Duplicates----------

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing

)															
SELECT *                             
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing

)															
DELETE                             
FROM RowNumCTE
WHERE row_num > 1



/*** I used the following command to delete the duplicate rows
DELETE                          
FROM RowNumCTE 
WHERE row_num > 1
***/

SELECT *
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing



-------Delete unused Column-------

SELECT *
FROM PORTFOLIO_PROJECT.dbo.NashvilleHousing

ALTER TABLE PORTFOLIO_PROJECT.dbo.NashvilleHousing
DROP COLUMN SaleDate, OwnerAddress, TaxDistrict, PropertyAddress, SaleDateConverted, SaleDateConvert