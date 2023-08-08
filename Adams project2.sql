SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[SaleDateconverted]
  FROM [Housing project].[dbo].[HousingProject]

  

  --- Cleaning Data in SQL Queries

 select*
 from HousingProject

 --- Sale Date Format

 
select SaleDate,  convert( date,SaleDate) 
 from HousingProject



 select SaleDate,  convert( date,SaleDate) as Date
 from HousingProject


 update HousingProject
  set SaleDate = convert( date,SaleDate) 
   

   
Alter Table HousingProject
  add SaleDateconverted  date;
   

   select SaleDate
   from HousingProject


   -- Property Address data

   
   select PropertyAddress 
   from HousingProject

   
   select PropertyAddress 
   from HousingProject
   where PropertyAddress is null 

   
   select *
   from HousingProject
   where PropertyAddress is null  

   
   select*
   from HousingProject
   where PropertyAddress is null 
   order by ParcelID

   select*
   from HousingProject a
    join HousingProject b 
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

	 select*
   from HousingProject a
    join HousingProject b 
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

	---- to compare the ParcelID and PropertyAddress columns 

	select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
   from HousingProject a
    join HousingProject b 
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

	---To populate the Address
	
	select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, 
	ISNULL(a.PropertyAddress,b.PropertyAddress)
   from HousingProject a
    join HousingProject b 
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

	update a
	set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
   from HousingProject a
    join HousingProject b 
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

	--Breaking out Address into Individual Columns(Address,City, State)


	  select PropertyAddress
   from HousingProject
   --where PropertyAddress is null 
   --order by ParcelID

   Select 
   SUBSTRING (Propertyaddress, 1, CHARINDEX ( ',', PropertyAddress)) as Address
    from HousingProject

	  Select 
   SUBSTRING (Propertyaddress, 1,CHARINDEX ( ',', PropertyAddress)) as Address,
   CHARINDEX ( ',', PropertyAddress)
    from HousingProject

	  Select 
   SUBSTRING (Propertyaddress, 1,CHARINDEX ( ',', PropertyAddress) -1) as Address
    from HousingProject

	
	  Select 
   SUBSTRING (Propertyaddress, 1,CHARINDEX ( ',', PropertyAddress) -1) as Address,
   
   SUBSTRING (Propertyaddress, CHARINDEX ( ',', PropertyAddress) +1, Len (PropertyAddress) ) as Address
    
	from HousingProject 


  Alter Table HousingProject
  add PropertySplitAddress nvarchar(255); 

	update HousingProject
	set PropertySplitAddress =  SUBSTRING (Propertyaddress, 1,CHARINDEX ( ',', PropertyAddress) -1)

 Alter Table HousingProject
  add PropertySplitAddress nvarchar(255);

  update HousingProject
	set PropertySplitAddress = SUBSTRING (Propertyaddress, CHARINDEX ( ',', PropertyAddress) +1, Len (PropertyAddress) )


	select*
	from HousingProject






   select OwnerAddress
	from HousingProject

	select  parsename (OwnerAddress, 1)
	from HousingProject

	-- take the comma to period. i.e full stop

	select  parsename (replace (OwnerAddress, ',', '.'), 1)
	from HousingProject

	-- parse take things from back 

    select  parsename (replace (OwnerAddress, ',', '.'), 1),
	        parsename (replace (OwnerAddress, ',', '.'), 2),
	        parsename (replace (OwnerAddress, ',', '.'), 3)
	from HousingProject

	-- to get the accurate address use this

	 select  parsename (replace (OwnerAddress, ',', '.'), 3),
	        parsename (replace (OwnerAddress, ',', '.'), 2),
	        parsename (replace (OwnerAddress, ',', '.'), 1)
	from HousingProject

	 
	 
  Alter Table HousingProject
  add OwnerSplitAddress nvarchar(255); 

	update HousingProject
	set OwnerSplitAddress = parsename (replace (OwnerAddress, ',', '.'), 3)

 Alter Table HousingProject
  add OwnerSplitCity nvarchar(255);

  update HousingProject
	set OwnerSplitCity  = parsename (replace (OwnerAddress, ',', '.'), 2)
	
	Alter Table HousingProject
  add OwnerSplitState nvarchar(255);

  update HousingProject
	set OwnerSplitState  = parsename (replace (OwnerAddress, ',', '.'), 1)

	 select* 
	from HousingProject 


	--change Y and N to Yes and No in "sold as vacant" field
	 

	  select distinct( SoldAsVacant), count (SoldAsVacant)
	  from HousingProject 
	  group by SoldAsVacant
	  order by 2

	    select SoldAsVacant,
		case when SoldAsVacant = 'Y' then 'Yes'
		     when SoldAsVacant = 'N' then 'No'
		    Else  SoldAsVacant
			End
	   from HousingProject


	   update HousingProject
	  set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		     when SoldAsVacant = 'N' then 'No'
		    Else  SoldAsVacant
			End
		from HousingProject
	   
	 
---	Remove  duplicates

 select* ,
 row_number () over( partition by UniqueID, ParcelID, 
     PropertyAddress,SaleDate
     order by ParcelID) row_num
	from HousingProject 

	-- let us use CTE

	with RowNumCTE as (
	 select* ,
 row_number () over( partition by  ParcelID,
      PropertyAddress,SaleDate,LegalReference
    order by UniqueID) row_num
	from HousingProject 
	)
	select *
	from RowNumCTE
	where row_num > 1
	order by PropertyAddress 


	--- to delete duplicate

	with RowNumCTE as (
	 select* ,
 row_number () over( partition by  ParcelID,
      PropertyAddress,SaleDate,LegalReference
    order by UniqueID) row_num
	from HousingProject 
	)
	delete
	from RowNumCTE
	where row_num > 1
	
	
	--- Delete Unused Columns 

	 

	alter table HousingProject 
	drop column OwnerAddress, TaxDistrict, PropertyAddress

	alter table HousingProject 
	drop column SaleDate
