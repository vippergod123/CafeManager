using KTPM_ProjectFinal.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KTPM_ProjectFinal.DAO
{
    public class AccountDAO
    {
        private static AccountDAO instance;

        public static AccountDAO Instance
        {
            get { if (instance == null) instance = new AccountDAO(); return instance; }
            private set { instance = value; }
        }

        private AccountDAO() { }

        public bool Login(string userName, string password)
        {
            string query = "USP_Login @username , @password";

            DataTable result = DataProvider.Instance.ExcuteQuery(query, new object[] {userName,password});
            return result.Rows.Count > 0;
        }

        public Account GetAccountByUserName(string userName)
        {
            string query = "Select * from account where userName = '" + userName + "'";
            DataTable data = DataProvider.Instance.ExcuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                return new Account(item);
            }

            return null;
        }

        public bool UpdateAccount(string userName, string displayName, string password, string newPass)
        {
            string query = "USP_UpdateAccount @userName , @displayName , @password , @newPassword";
            int result = DataProvider.Instance.ExcuteNonQuery(query, new object[]{userName, displayName, password, newPass});

            return result > 0;
        }
    }

}
