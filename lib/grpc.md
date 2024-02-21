1).了解protobuf信息交换协议
demo程序编译和运行
Tag-Length-Value
Length(可选的,如varint省略之,length-delimited需要),type为2
Tag-Value时
tpye为0,1,5之一

Tag本身采用varint编码的
(1111 1):field_number(111):wire_type一般取0,1,2,5;区别如下

wire_type	meaning	used for
0	varint	s/u,int32/64 bool enum
1	64-bit	fixed64,sfixed64,double
2	length-delimited	string,bytes,embedded messages,packed repeated fields
//3	start group	groups(弃用)
//4	end group	groups(弃用)
5	32-bit	fixed32,sfixed32,float


数据解码过程:https://protobuf.dev/programming-guides/encoding/#varints
varint(暂且叫它:变长整型)
int32、int64、uint32、uint64、bool、enum //其中int32,int64为负数时空间效率较低;bool为false(默认值)时存储为空(不占用字符);
a.按字节顺序读取,首位bit为1继续读,为0停止读
b.剔除首位bit,从尾部以7位为一个单位,从后往前,重组数据

负数编码过程(由于负数补码高位总为1,总是保持最大字节占用,没法去除前头多余的0,所以需要另一套zigzag转换为正数才能继续使用varint压缩高位0)//sint32和sint64应用该编码
a.先用zigzag将负数转为正数,对于32位整数
(n >> 1) ^ (n << 31)//解码
(n << 1) ^ (n >> 31)//编码,就是将数据整体左移,符号位溢出回到起始位;接着符号位不变,(若为负数)数据位按位取反
b.再用Varint编码

uint32_t zigzag_encode_32(int32_t val){
	return (uint32_t)( (val<<1)^(val>>31) );
}

uint32_t zigzag_decode_32(int32_t val){
	return (uint32_t)( (val>>1)^-(val&1) );//^,难道不该替换为|???	(后续编程验证下)
}
