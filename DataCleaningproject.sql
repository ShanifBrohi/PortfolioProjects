/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM SQLportfolioproject02.dbo.NashvilleHousing;

-----------------------------------------------------------------------------------

-- Standarized Date Format

SELECT SaleDateConverted, CONVERT(DATE,SaleDate)
FROM SQLportfolioproject02.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate);

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate);

---------------------------------------------------------------------------------

-- Populate Property Address Data


SELECT *
FROM SQLportfolioproject02.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;


SELECT a.ParcelID,
	   a.PropertyAddress,
	   b.ParcelID,
	   b.PropertyAddress
FROM SQLportfolioproject02.dbo.NashvilleHousing a
JOIN SQLportfolioproject02.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID AND a.[UniqueID ] != b.[UniqueID ]
;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM SQLportfolioproject02.dbo.NashvilleHousing a
JOIN SQLportfolioproject02.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


-----------------------------------------------------------------------------------

-- Breaking out Address into individual columns (Address, city, state)


SELECT PropertyAddress
FROM SQLportfolioproject02.dbo.NashvilleHousing;


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM SQLportfolioproject02.dbo.NashvilleHousing;


ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));


SELECT *
FROM SQLportfolioproject02.dbo.NashvilleHousing;




SELECT OwnerAddress
FROM SQLportfolioproject02.dbo.NashvilleHousing;


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM SQLportfolioproject02.dbo.NashvilleHousing;



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);



SELECT *
FROM SQLportfolioproject02.dbo.NashvilleHousing;


-----------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM SQLportfolioproject02.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN  SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM SQLportfolioproject02.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN  SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END;


----------------------------------------------------------------------------------
--Remove Duplicates

WITH RowNumCTE AS (

SELECT *,
	ROW_NUMBER() OVER(
		PARTIION BY parcelID,
			    propertyaddress,
			    saleprice,
			    saledate,
			    legalreference
			ORDER BY UniqueID
			) AS RowNum

FROM dbo.NashvilleHousing
--ORDER BY parcelID
)

DELETE 
FROM RowNumCTE
WHERE RowNum > 1
ORDER BY propertyaddress

------------------------------------------------------------------------------------

--Delete Unused Columns


SELECT *
FROM SQLportfolioproject02.dbo.NashvilleHousing;

ALTER TABLE SQLportfolioproject02.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict;

ALTER TABLE SQLportfolioproject02.dbo.NashvilleHousing
DROP COLUMN SaleDate;
