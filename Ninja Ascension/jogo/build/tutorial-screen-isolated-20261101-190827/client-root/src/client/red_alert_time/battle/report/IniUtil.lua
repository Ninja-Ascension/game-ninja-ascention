

IniUtil = {}

IniUtil.APP_NAME =  "Transformers Server Servlet"
IniUtil.APP_VERSION =  "0.1"
IniUtil.enter =  "\r\n"

IniUtil.compart =  " "

IniUtil.table =  "\t"

IniUtil.empty =  ""

IniUtil.comma =  ","


function IniUtil.concatTable(destTable, srcTable)
	for _, val in pairs(srcTable) do
		table.insert(destTable, val)
	end
end
