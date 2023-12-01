### 算法
1. 定义:明确的输入输出,可行的步骤
2. 循环:
3. 递归:可借助栈转换为循环,不过代价需要权衡;(尾递归某些编译器可直接优化为循环)
4. 时间复杂度:运行时间的增长趋势,一般优先时间(明显空间不足时才考虑空间),常数阶O(1)<对数阶O(log n)<线性阶O(n)<线性对数阶(O(nlog n)<平方阶O(n^2)<指数阶O(2^n)
5. 空间复杂度:占用内存空间的增长趋势

### 查找
#### 二分查找
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

### 排序
![sort](/images/sort.png)
#### 插入排序(n~n^2~~n^2 stable)
```zig
pub fn insertion(
    comptime T: type,
    items: []T,
    context: anytype,
    comptime lessThanFn: fn (@TypeOf(context), lhs: T, rhs: T) bool,
) void {
    const Context = struct {
        items: []T,
        sub_ctx: @TypeOf(context),

        pub fn lessThan(ctx: @This(), a: usize, b: usize) bool {
            return lessThanFn(ctx.sub_ctx, ctx.items[a], ctx.items[b]);
        }

        pub fn swap(ctx: @This(), a: usize, b: usize) void {
            return mem.swap(T, &ctx.items[a], &ctx.items[b]);
        }
    };
    insertionContext(0, items.len, Context{ .items = items, .sub_ctx = context });
}
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

#### 选择排序

#### 冒泡排序

#### 希尔排序

#### 堆排序3(nlogn~nlogn~~nlogn unstable)
```zig
pub fn heapContext(a: usize, b: usize, context: anytype) void {
    assert(a <= b);
    // build the heap in linear time.
    var i = a + (b - a) / 2;
    while (i > a) {
        i -= 1;
        siftDown(a, i, b, context);
    }

    // pop maximal elements from the heap.
    i = b;
    while (i > a) {
        i -= 1;
        context.swap(a, i);
        siftDown(a, a, i, context);
    }
}

fn siftDown(a: usize, target: usize, b: usize, context: anytype) void {
    var cur = target;
    while (true) {
        // When we don't overflow from the multiply below, the following expression equals (2*cur) - (2*a) + a + 1
        // The `+ a + 1` is safe because:
        //  for `a > 0` then `2a >= a + 1`.
        //  for `a = 0`, the expression equals `2*cur+1`. `2*cur` is an even number, therefore adding 1 is safe.
        var child = (math.mul(usize, cur - a, 2) catch break) + a + 1;

        // stop if we overshot the boundary
        if (!(child < b)) break;

        // `next_child` is at most `b`, therefore no overflow is possible
        const next_child = child + 1;

        // store the greater child in `child`
        if (next_child < b and context.lessThan(child, next_child)) {
            child = next_child;
        }

        // stop if the Heap invariant holds at `cur`.
        if (context.lessThan(child, cur)) break;

        // swap `cur` with the greater child,
        // move one step down, and continue sifting.
        context.swap(child, cur);
        cur = child;
    }
}
```

#### 快速排序1(nlogn~n^2~~nlogn unstable)
递归版改为非递归和迭代版:将信息push和pop到栈结构中或者存到范围数组std::pair<int,int> ranges[len];<br>
内省排序(introsort):快排递归深度达到阈值,退化为O(n^2),此时调整为堆排序,从而将最坏情况优化为nlogn;当元素数低于某个阈值,切换为插入排序<br>
pdqsort:introsort的改进版

#### 归并排序2(nlogn~nlogn~~nlogn stable)
块排序(block sort):混合插入和归并的排序

#### 计数排序

#### 基数排序

#### 桶排序

### 散列表

### 红黑树

### 贪心算法

### 动态规划

### 深度优先搜索

### 广度优先搜索

### 跳跃表
