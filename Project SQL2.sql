Select *
From PorfolioProject.dbo.NashvilleHouse


select SaleDate , convert(date,SaleDate) 
from PorfolioProject.dbo.NashvilleHouse


Update NashvilleHouse
Set SaleDate = convert(date,SaleDate) 
 -- Standardize Date Format
ALTER TABLE NashvilleHouse
Add SaleDateConverted Date

Update NashvilleHouse
set SaleDateConverted = convert(date,SaleDate) 

select SaleDateConverted
from NashvilleHouse
-- Standardize Date Format

Select *
From NashvilleHouse
--Where PropertyAddress is null
order by ParcelID


select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
from NashvilleHouse A
join NashvilleHouse B
on A.ParcelID=B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
Where a.PropertyAddress is null

Update A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
from NashvilleHouse A
join NashvilleHouse B
on A.ParcelID=B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
Where a.PropertyAddress is null


-- Populate Property Address data
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From NashvilleHouse

ALTER TABLE [dbo].[NashvilleHouse]
Add PropertySplitAddress Nvarchar(255);

Update [dbo].[NashvilleHouse]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )
Select *
From NashvilleHouse
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHouse
ALTER TABLE NashvilleHouse
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHouse
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
ALTER TABLE NashvilleHouse
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHouse
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHouse
Add OwnerSplitState Nvarchar(255);

Update NashvilleHouse
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
Select *
From NashvilleHouse


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHouse
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHouse

Update NashvilleHouse
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHouse
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From NashvilleHouse



