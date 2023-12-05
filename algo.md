### 算法
1. 定义:明确的输入输出,可行的步骤
2. 循环:
3. 递归:可借助栈转换为循环,不过代价需要权衡;(尾递归某些编译器可直接优化为循环)
4. 时间复杂度:运行时间的增长趋势,一般优先时间(明显空间不足时才考虑空间),  
常数阶O(1)<对数阶O(log n)<线性阶O(n)<线性对数阶O(nlog n)<平方阶O(n^2)<指数阶O(2^n)
5. 空间复杂度:占用内存空间的增长趋势

### 数组和链表
#### 数组:array

#### 数组的改进-vector/ArrayList动态数组,deque/SegmentedList类似半个deque

#### 链表:list/DoublyLinkedList,forward_list/SinglyLinkedList

#### 链表的改进-跳表
xxx

#### 数组链表的综合改进-哈希表(散列表)
通过建立键key与值value之间的映射,实现高效的元素查询.在哈希表中进行增删改查的时间复杂度都是O(1),非常高效.

##### 负载因子load factor
哈希表的元素数量除以桶数量,用于衡量哈希冲突的严重程度,也常作为哈希表扩容的触发条件.

##### 哈希冲突
通常情况下哈希函数的输入空间远大于输出空间,因此理论上哈希冲突是不可避免的.  
如f(x)=x % 100中137和237就冲突了.
* 扩容:粗暴有效,但效率低,仅当哈希冲突比较严重时才扩容
* 链式地址:数组中各元素作为桶,冲突时桶内存放链表/红黑树
* 开放寻址:都不能直接删除元素,需要懒删除lazy deletion机制来间接删除元素
  * 线性探测:冲突时偏移固定步长如1,易产生聚集效应
  * 平方探测:跳过'探测次数的平方'的步数,即1,2,9...步
  * 多次哈希:f1,f2,f3...进行探测,不易产生聚集,但会带来额外的计算量

##### 哈希算法
效率高和均匀分布
* 加法哈希:
* 乘法哈希:
* 异或哈希:
* 旋转哈希:


### 查找
#### 二分查找:自适应搜索
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
#### 树查找
例如二叉搜索树

#### 哈希查找
散列表通过散列函数查找

#### 线性搜索:暴力搜索(遍历)

#### 深度优先搜索
* 树:先序遍历,中序遍历,后序遍历
* 图

#### 广度优先搜索
* 树:层序遍历
* 图


### 排序
| 排序算法 | 平均复杂度 | 最好情况 | 最坏情况 | 空间复杂度 | 排序方式 | 稳定性 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 插入排序 | O(n^2) | O(n) | O(n^2) | O(1) | in-place | 稳定 |
| 选择排序 | O(n^2) | O(n^2) | O(n^2) | O(1) | in-place | 不稳定 |
| 冒泡排序 | O(n^2) | O(n) | O(n^2) | O(1) | in-place | 稳定 |
| 希尔排序 | - | - | - | O(1) | in-place | 不稳定 |
| 堆排序   | O(nlog n) | O(nlog n) | O(nlog n) | O(1) | in-place | 不稳定 |
| 快速排序 | O(nlog n) | O(nlog n) | O(n^2) | O(log n) | in-place | 不稳定 |
| 归并排序 | O(nlog n) | O(nlog n) | O(nlog n) | O(n) | out-place | 稳定 |
| 计数排序 | O(n+k) | O(n+k) | O(n+k) | O(k) | out-place | 稳定 |
| 基数排序 | O(n*k) | O(n*k) | O(n*k) | O(n+k) | out-place | 稳定 |
| 桶排序   | O(n+k) | O(n+k) | O(n^2) | O(n+k) | out-place | 稳定 |

#### 插入排序(n~n^2~~n^2 stable)
```c
/* 插入排序 */
void insertionSort(int nums[], int size) {
    // 外循环：已排序元素数量为 1, 2, ..., n
    for (int i = 1; i < size; i++) {
        int base = nums[i], j = i - 1;
        // 内循环：将 base 插入到已排序部分的正确位置
        while (j >= 0 && nums[j] > base) {
            // 将 nums[j] 向右移动一位
            nums[j + 1] = nums[j];
            j--;
        }
        // 将 base 赋值到正确位置
        nums[j + 1] = base;
    }
}
```
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
```cpp
/* 堆的长度为 n ，从节点 i 开始，从顶至底堆化 */
void siftDown(vector<int> &nums, int n, int i) {
    while (true) {
        // 判断节点 i, l, r 中值最大的节点，记为 ma
        int l = 2 * i + 1;
        int r = 2 * i + 2;
        int ma = i;
        if (l < n && nums[l] > nums[ma])
            ma = l;
        if (r < n && nums[r] > nums[ma])
            ma = r;
        // 若节点 i 最大或索引 l, r 越界，则无须继续堆化，跳出
        if (ma == i) {
            break;
        }
        // 交换两节点
        swap(nums[i], nums[ma]);
        // 循环向下堆化
        i = ma;
    }
}

/* 堆排序 */
void heapSort(vector<int> &nums) {
    // 建堆操作：堆化除叶节点以外的其他所有节点
    for (int i = nums.size() / 2 - 1; i >= 0; --i) {
        siftDown(nums, nums.size(), i);
    }
    // 从堆中提取最大元素，循环 n-1 轮
    for (int i = nums.size() - 1; i > 0; --i) {
        // 交换根节点与最右叶节点（交换首元素与尾元素）
        swap(nums[0], nums[i]);
        // 以根节点为起点，从顶至底进行堆化
        siftDown(nums, i, 0);
    }
}
```
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

```cpp
/* 选取三个元素的中位数 */
int medianThree(vector<int> &nums, int left, int mid, int right) {
    // 此处使用异或运算来简化代码
    // 异或规则为 0 ^ 0 = 1 ^ 1 = 0, 0 ^ 1 = 1 ^ 0 = 1
    if ((nums[left] < nums[mid]) ^ (nums[left] < nums[right]))
        return left;
    else if ((nums[mid] < nums[left]) ^ (nums[mid] < nums[right]))
        return mid;
    else
        return right;
}

/* 哨兵划分（三数取中值） */
int partition(vector<int> &nums, int left, int right) {
    // 选取三个候选元素的中位数
    int med = medianThree(nums, left, (left + right) / 2, right);
    // 将中位数交换至数组最左端
    swap(nums, left, med);
    // 以 nums[left] 为基准数
    int i = left, j = right;
    while (i < j) {
        while (i < j && nums[j] >= nums[left])
            j--; // 从右向左找首个小于基准数的元素
        while (i < j && nums[i] <= nums[left])
            i++;          // 从左向右找首个大于基准数的元素
        swap(nums, i, j); // 交换这两个元素
    }
    swap(nums, i, left); // 将基准数交换至两子数组的分界线
    return i;            // 返回基准数的索引
}
```

#### 归并排序2(nlogn~nlogn~~nlogn stable)
块排序(block sort):混合插入和归并的排序
```cpp
/* 合并左子数组和右子数组 */
void merge(vector<int> &nums, int left, int mid, int right) {
    // 左子数组区间 [left, mid], 右子数组区间 [mid+1, right]
    // 创建一个临时数组 tmp ，用于存放合并后的结果
    vector<int> tmp(right - left + 1);
    // 初始化左子数组和右子数组的起始索引
    int i = left, j = mid + 1, k = 0;
    // 当左右子数组都还有元素时，比较并将较小的元素复制到临时数组中
    while (i <= mid && j <= right) {
        if (nums[i] <= nums[j])
            tmp[k++] = nums[i++];
        else
            tmp[k++] = nums[j++];
    }
    // 将左子数组和右子数组的剩余元素复制到临时数组中
    while (i <= mid) {
        tmp[k++] = nums[i++];
    }
    while (j <= right) {
        tmp[k++] = nums[j++];
    }
    // 将临时数组 tmp 中的元素复制回原数组 nums 的对应区间
    for (k = 0; k < tmp.size(); k++) {
        nums[left + k] = tmp[k];
    }
}

/* 归并排序 */
void mergeSort(vector<int> &nums, int left, int right) {
    // 终止条件
    if (left >= right)
        return; // 当子数组长度为 1 时终止递归
    // 划分阶段
    int mid = (left + right) / 2;    // 计算中点
    mergeSort(nums, left, mid);      // 递归左子数组
    mergeSort(nums, mid + 1, right); // 递归右子数组
    // 合并阶段
    merge(nums, left, mid, right);
}
```

#### 计数排序
计数排序是桶排序在整型数据下的一个特例

#### 基数排序

#### 桶排序
```cpp
/* 桶排序 */
void bucketSort(vector<float> &nums) {
    // 初始化 k = n/2 个桶，预期向每个桶分配 2 个元素
    int k = nums.size() / 2;
    vector<vector<float>> buckets(k);
    // 1. 将数组元素分配到各个桶中
    for (float num : nums) {
        // 输入数据范围为 [0, 1)，使用 num * k 映射到索引范围 [0, k-1]
        int i = num * k;
        // 将 num 添加进桶 bucket_idx
        buckets[i].push_back(num);
    }
    // 2. 对各个桶执行排序
    for (vector<float> &bucket : buckets) {
        // 使用内置排序函数，也可以替换成其他排序算法
        sort(bucket.begin(), bucket.end());
    }
    // 3. 遍历桶合并结果
    int i = 0;
    for (vector<float> &bucket : buckets) {
        for (float num : bucket) {
            nums[i++] = num;
        }
    }
}
```

---
### 树

#### 二叉树的遍历与表示
* 完美二叉树(满二叉树):除叶节点外所有节点度(子节点)为2,呈现标准的指数级关系
* 完全二叉树:相对满二叉树,仅最底层右边的未填满
* 平衡二叉树:任意节点的左子树和右子树的高度之差的绝对值不超过1

广度优先搜索:层序遍历  
深度优先搜索:前序,中序,后序遍历;均为O(n)时间复杂度

表示:
* 完美二叉树/完全二叉树:i-left(2i+1)-right(2i+2),可用数组表示,典型代表堆排序中的构建大顶堆
* 任意二叉树:数组中为叶子的用INT_MAX表示,其它规则同上
* 任意树:左孩子右兄弟表示

#### 二叉搜索树:增删查时间复杂度均为O(log n),但存在退化为链表风险,此时O(n)
1. 对于根节点，左子树中所有节点的值<根节点的值<右子树中所有节点的值
2. 任意节点的左,右子树也是二叉搜索树

中序遍历有序:二叉搜索树的中序遍历序列是升序的

#### AVL树:平衡二叉搜索树

#### 红黑树
红黑树是一种自平衡二叉查找树,具有良好的效率,可以在O(log n)的时间复杂度下完成增删改查.  
特性:
* 节点是红色或黑色的
* 根和叶子都是黑色的
* 不能有两个连续的红色节点(代表红色节点的父和子节点都是黑色的)
* 从任意节点到叶子经过相同的黑节点(简称黑高)

#### b树(b-树)

#### b+树

#### b*树


---
### 图
分类:
* 有向图|无向图:关注和被关注是有方向的,好友是双向的
* 有权图|无权图:最短路径
* 连通图|非连通图:多起点

图的表示:
* 邻接矩阵:vector<vector<int>> adjMat;
* 邻接链表:unordered_map<Vertex *, vector<Vertex *>> adjList;

图的遍历:
* 广度优先
```cpp
/* 广度优先遍历 BFS */
// 使用邻接表来表示图，以便获取指定顶点的所有邻接顶点
vector<Vertex *> graphBFS(GraphAdjList &graph, Vertex *startVet) {
    // 顶点遍历序列
    vector<Vertex *> res;
    // 哈希表，用于记录已被访问过的顶点
    unordered_set<Vertex *> visited = {startVet};
    // 队列用于实现 BFS
    queue<Vertex *> que;
    que.push(startVet);
    // 以顶点 vet 为起点，循环直至访问完所有顶点
    while (!que.empty()) {
        Vertex *vet = que.front();
        que.pop();          // 队首顶点出队
        res.push_back(vet); // 记录访问顶点
        // 遍历该顶点的所有邻接顶点
        for (auto adjVet : graph.adjList[vet]) {
            if (visited.count(adjVet))
                continue;            // 跳过已被访问的顶点
            que.push(adjVet);        // 只入队未访问的顶点
            visited.emplace(adjVet); // 标记该顶点已被访问
        }
    }
    // 返回顶点遍历序列
    return res;
}
```
* 深度优先
```cpp
/* 深度优先遍历 DFS 辅助函数 */
void dfs(GraphAdjList &graph, unordered_set<Vertex *> &visited, vector<Vertex *> &res, Vertex *vet) {
    res.push_back(vet);   // 记录访问顶点
    visited.emplace(vet); // 标记该顶点已被访问
    // 遍历该顶点的所有邻接顶点
    for (Vertex *adjVet : graph.adjList[vet]) {
        if (visited.count(adjVet))
            continue; // 跳过已被访问的顶点
        // 递归访问邻接顶点
        dfs(graph, visited, res, adjVet);
    }
}

/* 深度优先遍历 DFS */
// 使用邻接表来表示图，以便获取指定顶点的所有邻接顶点
vector<Vertex *> graphDFS(GraphAdjList &graph, Vertex *startVet) {
    // 顶点遍历序列
    vector<Vertex *> res;
    // 哈希表，用于记录已被访问过的顶点
    unordered_set<Vertex *> visited;
    dfs(graph, visited, res, startVet);
    return res;
}
```

------
分治之后是算法第二阶段,需要更高深的理解力
------
### 分治
分而治之揭示了一个重要的事实:从简单做起,一切都不再复杂.  
分治算法递归地将原问题划分为多个相互独立的子问题,直至最小子问题,并在回溯中合并子问题的解,最终得到原问题的解.  
应用:
* 堆排序,快速排序,归并排序,桶排序
* 二分查找,哈希表,树
* 汉诺塔
```cpp
/* 移动一个圆盘 */
void move(vector<int> &src, vector<int> &tar) {
    // 从 src 顶部拿出一个圆盘
    int pan = src.back();
    src.pop_back();
    // 将圆盘放入 tar 顶部
    tar.push_back(pan);
}

/* 求解汉诺塔问题 f(i) */
void dfs(int i, vector<int> &src, vector<int> &buf, vector<int> &tar) {
    // 若 src 只剩下一个圆盘，则直接将其移到 tar
    if (i == 1) {
        move(src, tar);
        return;
    }
    // 子问题 f(i-1) ：将 src 顶部 i-1 个圆盘借助 tar 移到 buf
    dfs(i - 1, src, tar, buf);
    // 子问题 f(1) ：将 src 剩余一个圆盘移到 tar
    move(src, tar);
    // 子问题 f(i-1) ：将 buf 顶部 i-1 个圆盘借助 src 移到 tar
    dfs(i - 1, buf, src, tar);
}

/* 求解汉诺塔问题 */
void solveHanota(vector<int> &A, vector<int> &B, vector<int> &C) {
    int n = A.size();
    // 将 A 顶部 n 个圆盘借助 B 移到 C
    dfs(n, A, B, C);
}
```


### 回溯
回溯的力量让我们能够重新开始,不断尝试,最终找到通往光明的出口.  
回溯算法在尝试和回退中穷举所有可能的解,并通过剪枝避免不必要的搜索分支.  
回溯算法通常采用"深度优先搜索"来遍历解空间

1. 全排列问题:暂略

2. 子集和问题:暂略

3. N皇后问题:较复杂


### 动态规划
动态规划也对问题进行递归分解,但与分治算法的主要区别是,动态规划中的子问题是相互依赖的,在分解过程中会出现许多重叠子问题;  
动态规划常用来求解最优化问题,特性:
* 重叠子问题
* 最优子结构:
* 无后效性:
斐波那契数列f(n)=f(n-1)+f(n-2),n>1是典型的状态转移方程,适用动态规划

1. 初探:状态转移方程
```cpp
//给定一个共有n阶的楼梯，你每步可以上1阶或者2阶,请问有多少种方案可以爬到楼顶?
/* 爬楼梯：动态规划 */
int climbingStairsDP(int n) {
    if (n == 1 || n == 2)
        return n;
    // 初始化 dp 表，用于存储子问题的解
    vector<int> dp(n + 1);
    // 初始状态：预设最小子问题的解
    dp[1] = 1;
    dp[2] = 2;
    // 状态转移：从较小子问题逐步求解较大子问题
    for (int i = 3; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2];//状态转移方程
    }
    return dp[n];
}

/* 爬楼梯：空间优化后的动态规划 */
int climbingStairsDPComp(int n) {
    if (n == 1 || n == 2)
        return n;
    int a = 1, b = 2;
    for (int i = 3; i <= n; i++) {
        int tmp = b;
        b = a + b;
        a = tmp;
    }
    return b;
}
```

2. 0-1背包问题
```cpp
//给定n个物品,第i个物品的重量为wgt[i],价值为val[i],和一个容量为cap的背包.每个物品只能选择一次,问在限定背包容量下能放入物品的最大价值
/* 0-1 背包：空间优化后的动态规划 */
int knapsackDPComp(vector<int> &wgt, vector<int> &val, int cap) {
    int n = wgt.size();
    // 初始化 dp 表
    vector<int> dp(cap + 1, 0);
    // 状态转移
    for (int i = 0; i < n; i++) {
        // 倒序遍历
        for (int c = cap; c >= 1; c--) {
            if (wgt[i] <= c) {
                // 不选和选物品 i 这两种方案的较大值
                dp[c] = max(dp[c], dp[c - wgt[i]] + val[i]);
            }
        }
    }
    return dp[cap];
}
```

3. 完全背包:(特例零钱兑换)物品可重复选取,不再仅1次或0次
```cpp
//给定n个物品,第i个物品的重量为wgt[i-1],价值为val[i-1],和一个容量为cap的背包.每个物品可以重复选取,问在限定背包容量下能放入物品的最大价值.
/* 完全背包：空间优化后的动态规划 */

//给定n中硬币,第i中硬币的面值为coins[i-1],目标金额为amt,每种硬币可以重复选取,问能否凑出目标金额的最少硬币数量.如果无法凑出目标金额,则返回-1.

//给定n中硬币,第i中硬币的面值为coins[i-1],目标金额为amt,每种硬币可以重复选取,问凑出目标金额的硬币组合数量.
```


### 贪心算法:值得一试的捷径,有点魏延子午谷奇谋的意思
贪心地做出局部最优的决策,以期获得全局最优解(近似算法捷径);不同于动态规划会根据之前阶段的所有决策来考虑当前决策(用过去子问题解构建当前子问题的解)  
正确条件:每一步的最优解一定包含上一步的最优解

1. 零钱兑换：贪心 (精心设计的钱币对贪心算法有适配,否则动态规划才能达到最优)
```c
/* 零钱兑换：贪心 */
int coinChangeGreedy(int *coins, int size, int amt) {
    // 假设 coins 列表有序
    int i = size - 1;
    int count = 0;
    // 循环进行贪心选择，直到无剩余金额
    while (amt > 0) {
        // 找到小于且最接近剩余金额的硬币
        while (i > 0 && coins[i] > amt) {
            i--;
        }
        // 选择 coins[i]
        amt -= coins[i];
        count++;
    }
    // 若未找到可行方案，则返回 -1
    return amt == 0 ? count : -1;
}
```

2. 分数背包问题
