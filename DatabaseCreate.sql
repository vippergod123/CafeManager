Create Database QuanLyQuanCafe
Go

USE QuanLyQuanCafe
Go

--Food 
--Table
--Food Category
-- Account

Create Table TableFood  ( 
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100)NOT NULL DEFAULT N'Bàn Chưa có tên',
	status NVARCHAR(100) DEFAULT N'Trống',
)
Go

Create Table Account (
	
	userName NVARCHAR(100) PRIMARY KEY,
	displayName NVARCHAR(100) NOT NULL DEFAULT N'SD74',
	password NVARCHAR(100) NOT NULL DEFAULT 0,
	type Int  NOT NULL DEFAULT 0,
)
Go

Create Table FoodCategory (
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chưa đặt tên',
)
Go

Create Table Food (
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chưa đặt tên',
	idCategory INT NOT NULL,
	price Float NOT NULL Default 0, 

	FOREIGN KEY (idCategory) REFERENCES dbo.FoodCategory(id),
)
Go

Create Table Bill (
	id INT IDENTITY PRIMARY KEY,
	DateCheckIn date NOT NULL,
	DateCheckOut Date,
	idTable Int NOT NULL, 
	status Int NOT NULL Default 0,

	FOREIGN KEY (idTable) REFERENCES dbo.TableFood(id),
)
Go

Create Table BillInfo (
	id INT IDENTITY PRIMARY KEY,
	idBill INT NOT NULL, 
	idFood Int NOT NULL,
	count INT NOT NULL Default 0

	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idFood) REFERENCES dbo.Food(id),
) 
Go


Insert into dbo.Account 
	(
		UserName,
		DisplayName,
		Password,
		Type
	)
VALUES (
	N'admin',
	N'Quản trị viên',
	N'1',
	1
)

Insert into dbo.Account 
	(
		UserName,
		DisplayName,
		Password,
		Type
	)
VALUES (
	N'staff',
	N'Nhân Viên',
	N'1',
	0
)


Create PROC USP_GetAccountByUserName 
@userName nvarchar(100)
as
Begin
	Select * from dbo.Account where UserName = @userName
end
go

Exec dbo.USP_GetAccountByUserName @userName = N'admin' 

Select * from dbo.Account where userName = N'admin' AND password = N'1'

Create Proc USP_Login 
@userName NVARCHAR(100), @password nvarChar(100)
as 
Begin
	Select * from dbo.Account where userName = @userName AND Password = @password
End
Go

Declare @i int  = 0 

while @i < 10 
begin 
	insert dbo.TableFood (name) values (N'Bàn ' + Cast (@i as NVARCHAR(100)))
	Set @i = @i + 1
end

--DBCC CHECKIDENT ('[TableFood]', RESEED, 0);  --reset ID identity = 0 
--GO
--DELETE FROM TableFood
--Drop Table TableFood

Create Proc USP_GetTableList
As Select * from dbo.TableFood
go

Update Dbo.TableFood Set Status = N'Có người' where id = 4

Exec dbo.USP_GetTableList 

-- Category
Insert Dbo.FoodCategory (name)
Values (N'Hải sản')

Insert Dbo.FoodCategory (name)
Values (N'Món ăn')

Insert Dbo.FoodCategory (name)
Values (N'Nước ngọt')

-- Thêm món ăn
--Hải sản
Insert Dbo.Food (name, idCategory, price)
Values (N'Mực', 1, 120000)
Insert Dbo.Food (name, idCategory, price)
Values (N'Mực', 1, 120000)
Insert Dbo.Food (name, idCategory, price)
Values (N'Mực', 1, 120000)

--Món ăn
Insert Dbo.Food (name, idCategory, price)
Values (N'Cơm', 2, 25000)
Insert Dbo.Food (name, idCategory, price)
Values (N'Hủ Tiếu', 2, 20000)
Insert Dbo.Food (name, idCategory, price)
Values (N'Cháo', 2, 10000)

--Nước ngọt
Insert Dbo.Food (name, idCategory, price)
Values (N'Coke', 3, 10000)
Insert Dbo.Food (name, idCategory, price)
Values (N'7Up', 3, 12000)
Insert Dbo.Food (name, idCategory, price)
Values (N'Sprite', 3, 11000)

--Thêm Bill
Insert Dbo.Bill (DateCheckIn,DateCheckOut,idTable,status) 
Values (GetDate(), NULL, 1, 0)

Insert Dbo.Bill (DateCheckIn,DateCheckOut,idTable,status) 
Values (GetDate(), GetDate(), 2, 0)

Insert Dbo.Bill (DateCheckIn,DateCheckOut,idTable,status) 
Values (GetDate(), GetDate(), 2, 1)

--Thêm BillInfo
Insert Dbo.BillInfo(idBill, idFood, count) 
values (1,1,2)

Insert Dbo.BillInfo(idBill, idFood, count) 
values (1,3,4)

Insert Dbo.BillInfo(idBill, idFood, count) 
values (1,5,1)

Select * from Bill
Select * from BillInfo


Select f.name, bi.count, f.price, f.price * bi.count as totalPrice from dbo.BillInfo as bi, dbo.Bill as b, dbo.Food as f
Where bi.idBill = b.id and bi.idFood = f.id and b.idTable = 1 and b.status = 0

Select* from food

Create Proc USP_InsertBill
@idTable Int 
as 
Begin 
	Insert dbo.Bill(DateCheckIn,DateCheckOut,idTable,status)
	Values (GETDATE(), NULL, @idTable, 0)
End
Go

Create Proc USP_InsertBillInfo
@idBill Int , @idFood Int, @count Int 
as 
Begin 

	Declare @isExistBillInfo Int
	Declare @foodCount Int = 1

	Select @isExistBillInfo = id, @foodCount = b.count 
	From Dbo.BillInfo as b
	Where idBill = @idBill and idFood = @idFood

	IF(@isExistBillInfo > 0 )
	Begin
		Declare @newCount Int = @foodCount + @count
		IF(@newCount > 0)
			Update dbo.BillInfo set count = @foodCount + @count where idFood = @idFood
		Else
			Delete dbo.BillInfo Where idBill = @idBill and idFood = @idFood
	End
	
	ELSE

	Begin
		Insert dbo.BillInfo(idBill, idFood, count)
		Values (@idBill, @idFood, @count)
	End
	
End
Go

update Dbo.bill set status = 1 where id = 1

Delete dbo.Bill
Delete dbo.BillInfo

Create Trigger UTG_UpdateBillInfo
On Dbo.BillInfo for Insert, Update
As
Begin
	Declare @idBill int
	Select @idBill = idBill From inserted

	Declare @idTable Int
	Select @idTable = idTable From dbo.Bill Where id = @idBill and Status = 0
	
	Update dbo.TableFood set Status = N'Có Người' Where id = @idTable 
End
Go

Create Trigger UTG_UpdateBill 
On Dbo.Bill for Update 
As 
Begin 
	Declare @idBill Int
	Select @idBill = id From inserted

	Declare @idTable Int 
	Select @idTable = idTable from Dbo.Bill Where id = @idBill

	Declare @count int =0  
	Select @count = count(*) from dbo.Bill Where idTable = @idTable and status = 0

	if (@count = 0 )
		Update dbo.TableFood set status = N'Trống' Where id = @idTable
End
Go

--Create Proc USP_SwitchTable
--@idTable1 int, @idTable2 Int 
--as
--Begin
	
--	Declare @idFirstBill Int
--	Declare @idSecondBill Int

--	Select @idFirstBill = id from dbo.Bill where idTable = @idTable2 and status = 0
--	Select @idSecondBill = id from dbo.Bill where idTable = @idTable1 and status = 0

--	IF (@idFirstBill = NULL) 
--	Begin 
--		Insert dbo.Bil

--	Select id into IDBillInfoTable From dbo.BillInfo where idBill = @idSecondBill

--	Update dbo.BillInfo Set idBill = @idSecondBill where idBill = @idFirstBill

--	Update dbo.BillInfo set idBill = @idFirstBill where id In ( Select * from IDBillInfoTable)

--	Drop Table IDBillInfoTable
--End
--Go

Delete Dbo.Bill

Alter Table dbo.Bill add totalPrice Float

Delete dbo.BillInfo
Delete dbo.Bill
Go

Create Proc USP_GetListbillByDate
@checkIn date, @checkOut date
As
Begin
	Select t.name as [Tên Bàn],  b.totalPrice as [Thanh toán],  DateCheckIn as [Check-In date], DateCheckOut as [Check-Out date]
	From dbo.Bill as b, dbo.TableFood as t
	where DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut and b.status = 1
		And t.id = b.idTable
End
Go

Create Proc USP_UpdateAccount 
@userName NVARCHAR(100), @displayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
Begin

	Declare @isRightPass int = 0
	Select @isRightPass = Count(*) from dbo.Account where UserName = @userName and Password = @password

	IF ( @isRightPass = 1) 
	Begin
		IF( @newPassword = NULL OR @newPassword = '')
		Begin
			Update dbo.Account Set DisplayName =@displayName where UserName = @userName
		End
		ELSE 
			Update dbo.Account Set DisplayName = @displayName, Password = @newPassword where UserName = @userName

	End
End
Go

Select * from dbo.Account