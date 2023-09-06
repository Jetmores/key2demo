## [UML类图](https://design-patterns.readthedocs.io/zh_CN/latest/index.html)
### 实现
继承抽象类,虚线三角(被指向者是基类)

### 泛化
继承普通类,实线三角(被指向者是基类)

### 依赖
使用,通常作参数/局部变量/全局变量,虚线箭头(被指向者是参数)

### 关联
使用,通常作属性(成员变量),个体与个体的平级关系(区别于聚合和组合的个体与整体的关系),实线箭头

### 聚合
使用,作属性,外部独立对象传参构造,可脱离,空心菱形

### 组合
使用,作属性,局部构造,不可脱离,实心菱形

## [设计模式](https://design-patterns.readthedocs.io/zh_CN/latest/index.html)
### 单例模式:创建型模式
单例模式本质是某命名空间下的全局变量;渐渐被依赖注入所替代
```cpp
//单例模式-局部静态变量:禁用拷贝构造赋值,私有默认构造和析构
class Singleton {
public:
	static Singleton& getInstance(){
		static Singleton instance;
		return instance;
	}
private:
	Singleton ()= default;
	~Singleton ()= default;
	Singleton (const Singleton &)= delete;
	Singleton & operator=(const Singleton &)= delete;
};
```
### 原型模式
类似Abstract* clone()方法,返回克隆的基类指针等

### 建造者模式
典型的聚合关系,抽象类建造者作属性,且建造者作方法参数,参数再泛化具体建造者

### 简单工厂模式
根据既定参数不同,在工厂方法中直接new继承链中的派生类,返回基类指针

### 工厂方法模式
在简单工厂的基础上将new移到派生工厂类的方法中,同样返回产品的基类指针

### 抽象工厂模式
在工厂方法的基础上,新增另一个派生类工厂类方法,以生产另一类产品,使工厂生产多样化(水平扩展)

### 适配器模式:结构型模式
对象适配器:类似聚合,但实际是关联关系;使用(依赖)适配基类,适配派生类关联另一类适配者到属性(对象),方法中传入新适配者的指针(以设定对象)

类适配器:在对象基础上,调整派生适配器继承新适配器

### 策略模式:行为型模式
典型的聚合关系,抽象类策略作属性,且策略指针作方法参数,参数再泛化具体策略

