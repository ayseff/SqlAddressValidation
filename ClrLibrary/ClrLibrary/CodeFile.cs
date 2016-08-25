using System;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using System.Xml;
using Microsoft.SqlServer.Server;
using System.Linq;
using System.Security;


// ReSharper disable InconsistentNaming

namespace ClrLibrary
{
    /// <summary>
    ///
    /// </summary>
    public partial class UserDefinedFunctions
    {
        /// <summary>
        /// https://www.usps.com/business/web-tools-apis/address-information-api.htm#_Toc410982981
        /// </summary>
        /// <param name="FirmName"></param>
        /// <param name="Address1"></param>
        /// <param name="Address2"></param>
        /// <param name="City"></param>
        /// <param name="State"></param>
        /// <param name="Zip5"></param>
        /// <param name="Zip4"></param>
        /// <returns></returns>
        [SqlFunction]
        public static SqlXml GetValidatedAddress(SqlString FirmName, SqlString Address1, SqlString Address2, SqlString City,
            SqlString State, SqlString Zip5, SqlString Zip4)
        {

            XmlDocument doc = new XmlDocument();
            string schema = "http://";
            string variant = "production";
            string host = ".shippingapis.com";
            string API = "/ShippingAPI.dll?API=Verify";
            string userID = GetUserName();

            //// not required for this particular API call:
            //string password = GetPassword();

            string xml = @"<AddressValidateRequest USERID=""" + userID + @""">"
                         + "<IncludeOptionalElements>true</IncludeOptionalElements>"
                         + @"<Address ID=""0"">"
                         + "<FirmName>" + FirmName.ToString() + "</FirmName>"
                         + "<Address1>" + Address1.ToString() + "</Address1>"
                         + "<Address2>" + Address2.ToString() + "</Address2>"
                         + "<City>" + City.ToString() + "</City>"
                         + "<State>" + State.ToString() + "</State>"
                         + "<Zip5>" + Zip5.ToString() + "</Zip5>"
                         + "<Zip4>" + Zip4.ToString() + "</Zip4></Address></AddressValidateRequest>";

            // Removing all whitespace from a string efficiently: http://stackoverflow.com/a/2865931/1378356
            xml = Regex.Replace(xml, @"^\s*$\n", string.Empty, RegexOptions.Multiline);

            string url = schema + variant + host + API + "&XML=" + xml;
            string response = HttpGet(url);
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(response);

            using (XmlNodeReader xnr = new XmlNodeReader(xmlDoc))
            {
                SqlXml sqlXml = new SqlXml(xnr);
                return sqlXml;
            }

        }

        private static string GetPassword()
        {
            throw new NotImplementedException();
        }

        private static string GetUserName()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// http://www.hanselman.com/blog/HTTPPOSTsAndHTTPGETsWithWebClientAndCAndFakingAPostBack.aspx
        /// </summary>
        /// <param name="URI"></param>
        /// <returns></returns>
        public static string HttpGet(string URI)
        {
            //    var client = new WebClient();
            //    var ret = client.DownloadString(URI);

            var req = WebRequest.Create(URI);
            //req.Proxy = new WebProxy("", true);
            //req.Proxy = new System.Net.WebProxy(ProxyString, true); //true means no proxy
            var resp = req.GetResponse();
            // ReSharper disable once AssignNullToNotNullAttribute
            var sr = new StreamReader(resp.GetResponseStream());
            var ret = sr.ReadToEnd().Trim();

            return ret;
        }

    }
}