### 查找
二分查找
```zig
pub fn binarySearch(
    comptime T: type,
    key: anytype,
    items: []const T,
    context: anytype,
    comptime compareFn: fn (context: @TypeOf(context), key: @TypeOf(key), mid_item: T) math.Order,
) ?usize {
    var left: usize = 0;
    var right: usize = items.len;

    while (left < right) {
        // Avoid overflowing in the midpoint calculation
        const mid = left + (right - left) / 2;
        // Compare the key with the midpoint element
        switch (compareFn(context, key, items[mid])) {
            .eq => return mid,
            .gt => left = mid + 1,
            .lt => right = mid,
        }
    }

    return null;
}
```

### 插入排序
```zig
pub fn insertionContext(a: usize, b: usize, context: anytype) void {
    assert(a <= b);

    var i = a + 1;
    while (i < b) : (i += 1) {
        var j = i;
        while (j > a and context.lessThan(j, j - 1)) : (j -= 1) {
            context.swap(j, j - 1);
        }
    }
}
```

### 选择排序

### 冒泡排序

### 希尔排序

### 堆排序3

### 快速排序1

### 归并排序2

### 计数排序

### 基数排序

### 桶排序

### 散列表

### 红黑树

### 贪心算法

### 动态规划

### 深度优先搜索

### 广度优先搜索

### 跳跃表
