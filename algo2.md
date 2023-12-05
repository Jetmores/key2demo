### 回溯
回溯的力量让我们能够重新开始,不断尝试,最终找到通往光明的出口.  
回溯算法在尝试和回退中穷举所有可能的解,并通过剪枝避免不必要的搜索分支.  
回溯算法通常采用"深度优先搜索"来遍历解空间

1. 全排列问题:暂略

2. 子集和问题:暂略

3. N皇后问题
```cpp
//根据国际象棋的规则,皇后可以攻击与同处一行,一列或一条斜线上的棋子.给定n个皇后和一个n*n大小的棋盘,寻找使得所有皇后之间无法相互攻击的摆放方案.
/* 回溯算法：N 皇后 */
void backtrack(int row, int n, vector<vector<string>> &state, vector<vector<vector<string>>> &res, vector<bool> &cols,
               vector<bool> &diags1, vector<bool> &diags2) {
    // 当放置完所有行时，记录解
    if (row == n) {
        res.push_back(state);
        return;
    }
    // 遍历所有列
    for (int col = 0; col < n; col++) {
        // 计算该格子对应的主对角线和副对角线
        int diag1 = row - col + n - 1;
        int diag2 = row + col;
        // 剪枝：不允许该格子所在列、主对角线、副对角线上存在皇后
        if (!cols[col] && !diags1[diag1] && !diags2[diag2]) {
            // 尝试：将皇后放置在该格子
            state[row][col] = "Q";
            cols[col] = diags1[diag1] = diags2[diag2] = true;
            // 放置下一行
            backtrack(row + 1, n, state, res, cols, diags1, diags2);
            // 回退：将该格子恢复为空位
            state[row][col] = "#";
            cols[col] = diags1[diag1] = diags2[diag2] = false;
        }
    }
}

/* 求解 N 皇后 */
vector<vector<vector<string>>> nQueens(int n) {
    // 初始化 n*n 大小的棋盘，其中 'Q' 代表皇后，'#' 代表空位
    vector<vector<string>> state(n, vector<string>(n, "#"));
    vector<bool> cols(n, false);           // 记录列是否有皇后
    vector<bool> diags1(2 * n - 1, false); // 记录主对角线上是否有皇后
    vector<bool> diags2(2 * n - 1, false); // 记录副对角线上是否有皇后
    vector<vector<vector<string>>> res;

    backtrack(0, n, state, res, cols, diags1, diags2);

    return res;
}
```

### 动态规划
动态规划也对问题进行递归分解,但与分治算法的主要区别是,动态规划中的子问题是相互依赖的,在分解过程中会出现许多重叠子问题;  
动态规划常用来求解最优化问题,特性:
* 重叠子问题
* 最优子结构:
* 无后效性:

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
int unboundedKnapsackDPComp(vector<int> &wgt, vector<int> &val, int cap) {
    int n = wgt.size();
    // 初始化 dp 表
    vector<int> dp(cap + 1, 0);
    // 状态转移
    for (int i = 1; i <= n; i++) {
        for (int c = 1; c <= cap; c++) {
            if (wgt[i - 1] > c) {
                // 若超过背包容量，则不选物品 i
                dp[c] = dp[c];
            } else {
                // 不选和选物品 i 这两种方案的较大值
                dp[c] = max(dp[c], dp[c - wgt[i - 1]] + val[i - 1]);
            }
        }
    }
    return dp[cap];
}

//给定n中硬币,第i中硬币的面值为coins[i-1],目标金额为amt,每种硬币可以重复选取,问能否凑出目标金额的最少硬币数量.如果无法凑出目标金额,则返回-1.
/* 零钱兑换：空间优化后的动态规划 */
int coinChangeDPComp(vector<int> &coins, int amt) {
    int n = coins.size();
    int MAX = amt + 1;
    // 初始化 dp 表
    vector<int> dp(amt + 1, MAX);
    dp[0] = 0;
    // 状态转移
    for (int i = 1; i <= n; i++) {
        for (int a = 1; a <= amt; a++) {
            if (coins[i - 1] > a) {
                // 若超过目标金额，则不选硬币 i
                dp[a] = dp[a];
            } else {
                // 不选和选硬币 i 这两种方案的较小值
                dp[a] = min(dp[a], dp[a - coins[i - 1]] + 1);
            }
        }
    }
    return dp[amt] != MAX ? dp[amt] : -1;
}

//给定n中硬币,第i中硬币的面值为coins[i-1],目标金额为amt,每种硬币可以重复选取,问凑出目标金额的硬币组合数量.
/* 零钱兑换 II：空间优化后的动态规划 */
int coinChangeIIDPComp(vector<int> &coins, int amt) {
    int n = coins.size();
    // 初始化 dp 表
    vector<int> dp(amt + 1, 0);
    dp[0] = 1;
    // 状态转移
    for (int i = 1; i <= n; i++) {
        for (int a = 1; a <= amt; a++) {
            if (coins[i - 1] > a) {
                // 若超过目标金额，则不选硬币 i
                dp[a] = dp[a];
            } else {
                // 不选和选硬币 i 这两种方案之和
                dp[a] = dp[a] + dp[a - coins[i - 1]];
            }
        }
    }
    return dp[amt];
}
```

4. 编辑距离问题
```cpp
//输入两个字符串s和t,返回将s转换为t所需的最少编辑步数.你可以在一个字符串中进行三种编辑操作:插入一个字符,删除一个字符,将字符替换为任意一个字符.
/* 编辑距离：空间优化后的动态规划 */
int editDistanceDPComp(string s, string t) {
    int n = s.length(), m = t.length();
    vector<int> dp(m + 1, 0);
    // 状态转移：首行
    for (int j = 1; j <= m; j++) {
        dp[j] = j;
    }
    // 状态转移：其余行
    for (int i = 1; i <= n; i++) {
        // 状态转移：首列
        int leftup = dp[0]; // 暂存 dp[i-1, j-1]
        dp[0] = i;
        // 状态转移：其余列
        for (int j = 1; j <= m; j++) {
            int temp = dp[j];
            if (s[i - 1] == t[j - 1]) {
                // 若两字符相等，则直接跳过此两字符
                dp[j] = leftup;
            } else {
                // 最少编辑步数 = 插入、删除、替换这三种操作的最少编辑步数 + 1
                dp[j] = min(min(dp[j - 1], dp[j]), leftup) + 1;
            }
            leftup = temp; // 更新为下一轮的 dp[i-1, j-1]
        }
    }
    return dp[m];
}
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
```cpp
//给定n个物品,第i个物品的重量为wgt[i-1],价值为val[i-1],和一个容量为cap的背包.每个物品只能选择一次,但可以选择物品的一部分,价值根据选择的重量比例计算,问在限定背包容量下背包中物品的最大价值.
/* 物品 */
class Item {
  public:
    int w; // 物品重量
    int v; // 物品价值

    Item(int w, int v) : w(w), v(v) {
    }
};

/* 分数背包：贪心 */
double fractionalKnapsack(vector<int> &wgt, vector<int> &val, int cap) {
    // 创建物品列表，包含两个属性：重量、价值
    vector<Item> items;
    for (int i = 0; i < wgt.size(); i++) {
        items.push_back(Item(wgt[i], val[i]));
    }
    // 按照单位价值 item.v / item.w 从高到低进行排序
    sort(items.begin(), items.end(), [](Item &a, Item &b) { return (double)a.v / a.w > (double)b.v / b.w; });
    // 循环贪心选择
    double res = 0;
    for (auto &item : items) {
        if (item.w <= cap) {
            // 若剩余容量充足，则将当前物品整个装进背包
            res += item.v;
            cap -= item.w;
        } else {
            // 若剩余容量不足，则将当前物品的一部分装进背包
            res += (double)item.v / item.w * cap;
            // 已无剩余容量，因此跳出循环
            break;
        }
    }
    return res;
}
```

3. 最大容量问题  
无法一眼看出

4. 最大切分乘法问题  
无法一眼看出