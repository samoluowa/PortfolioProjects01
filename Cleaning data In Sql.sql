-- Standerdize sale date 

SELECT SaleDateConverted, Convert(Date, Saledate)
  FROM [portfolio project].[dbo].[NashvilleHousing]
   
update [portfolio project].[dbo].[Nashville Housing]
SET saledate = convert(date, saledate)

Alter table nashvilleHousing
ADD SaleDateConverted Date;

update nashvillehousing
SET SaleDateConverted = Convert(Date, SaleDate)

---- populate property address

Select PropertyAddress
From [portfolio project].dbo.[NashvilleHousing]
where PropertyAddress is null

Select *
From [portfolio project].[dbo].[NashvilleHousing]
order by ParcelId


Select a.parcelid, a.propertyAddress, b.parcelid, b.propertyaddress, isnull(a.propertyAddress,b.propertyAddress)
From [portfolio project].[dbo].[NashvilleHousing] a
JOIN [portfolio project].[dbo].[NashvilleHousing] b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
Where a.propertyaddress is null

update a
SET propertyaddress =  isnull(a.propertyAddress,b.propertyAddress)
--Select a.parcelid, a.propertyAddress, b.parcelid, b.propertyaddress, isnull(a.propertyAddress,b.propertyAddress)
From [portfolio project].[dbo].[NashvilleHousing] a
JOIN [portfolio project].[dbo].[NashvilleHousing] b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
Where a.propertyaddress is null

---breaking out address into individual columns (Addres, City, State)

Select propertyaddress
From [portfolio project].dbo.NashvilleHousing

Select 
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress) + 1 , len(propertyaddress)) AS Address
From [portfolio project].dbo.NashvilleHousing

Alter table nashvilleHousing
ADD PropertySplitAddress NvarChar(MAX);

update nashvillehousing
SET PropertySplitAddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1 )


Alter table nashvilleHousing
ADD PropertySplitCity NvarChar(MAX);

update nashvillehousing
SET PropertySplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress) + 1 , len(propertyaddress)) 


Select *
From [portfolio project].dbo.NashvilleHousing

--owner-- persname-- easir method
Select OwnerAddress
From [portfolio project].dbo.NashvilleHousing

Select PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
 PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From [portfolio project].dbo.NashvilleHousing


Alter table nashvilleHousing
ADD OwnerSplitAddress NvarChar(MAX);

update nashvillehousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)


Alter table nashvilleHousing
ADD OwnerSplitCity NvarChar(MAX);

update nashvillehousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter table nashvilleHousing
ADD OwnerSplitState NvarChar(MAX);

update nashvillehousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1) 



---- Change Y and N to Yes and No in "Sold As Vancant"

Select distinct(SoldAsVacant), count(soldasvacant)
From [portfolio project].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
 Case When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
	  END
From [portfolio project].dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
	  END

--- Remove Duplicate

With RowNumCTE AS (
 Select *, 
	ROW_NUMBER() Over (
	PARTITION BY ParcelId,
				 Propertyaddress,
				 SalePrice,
				 saleDate,
				 LegalReference
				 Order By
					UniqueID
					) Row_Num

 From [portfolio project].dbo.NashvilleHousing
 --Order By ParcelID
 )



 Select *
 From RowNumCTE
 Where Row_Num > 1 
 Order By PropertyAddress

 --- Delete Unused Columns

 Select * 
 From [portfolio project].Dbo.NashvilleHousing

 Alter Table [portfolio project].Dbo.NashvilleHousing
 DROP COLUMN PropertSplitCity, PropertSplitAddress, SaleDate