using KTPM_ProjectFinal.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KTPM_ProjectFinal.DAO
{
    public class BillDAO
    {
        private static BillDAO instance;

        public static BillDAO Instance
        {
            get { 
                if (instance == null)
                    instance = new BillDAO();
                return BillDAO.instance; 
            }
            private set { BillDAO.instance = value; }
        }

        private BillDAO() { }

        public int GetUncheckBillIDByTableID(int id)
        {
            string query = "Select * from dbo.Bill Where idTable = "+ id +" And status = 0 ";
            DataTable data = DataProvider.Instance.ExcuteQuery(query);
            if (data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return bill.ID;
            }
            return -1;
        }

        public void InsertBill(int id)
        {
            string query = "USP_InsertBill @idTable";
            DataProvider.Instance.ExcuteQuery(query, new Object[] { id });
        }

        public int GetMaxBill()
        {
            try
            {
                string query = "Select Max(id) from dbo.Bill";
                return (int)DataProvider.Instance.ExcuteScalar(query);
            }
            catch 
            {
                return 1;
            }
        }

        public DataTable GetBillListByDate(DateTime checkIn, DateTime checkOut)
        {
            string query = "USP_GetListBillByDate @checkIn , @checkOut";
            return DataProvider.Instance.ExcuteQuery(query, new object[] { checkIn, checkOut });
        }

        public void CheckOut(int id, float totalPrice)
        {
            string query = "Update dbo.Bill set dateCheckOut = GETDATE(), status = 1, totalPrice = "+ totalPrice +" where id = " + id;
            DataProvider.Instance.ExcuteQuery(query);
        }
    }
}
