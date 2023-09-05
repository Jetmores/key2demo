## UML类图
### 实现
继承抽象类,虚线三角(被指向者是基类)

### 泛化
继承普通类,实线三角(被指向者是基类)

### 依赖
通常作参数/局部变量/全局变量,虚线箭头(被指向者是参数)

### 关联
通常作属性(成员变量),实线箭头

### 聚合
空心菱形

### 组合
实心菱形

## 设计模式
### 单例模式
单例模式本质是某命名空间下的全局变量
```c
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