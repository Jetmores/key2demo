### 浏览器中设定帮助rust文档 ?manpage
1. Chrome-设置-搜索引擎-管理搜索引擎和网站搜素-网站搜索-新增
2. Edge-设置-搜:地址栏和搜索-管理搜索引擎-添加
```rs
rs
rs
https://doc.rust-lang.org/std/index.html?search=%s
```

### ?遍历 ?目录 ?workdir
```rs
use std::fs;

fn main() -> std::io::Result<()> {
    for entry in fs::read_dir(".")? {
        let dir = entry?;
        println!("{:?}", dir.path());
    }
    Ok(())
}
```
