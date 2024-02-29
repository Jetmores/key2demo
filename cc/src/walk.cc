#include <algorithm>
#include <filesystem>
#include <fstream>
#include <iostream>

int main()
{
  const std::filesystem::path sandbox { "sandbox" };
  std::filesystem::create_directories(sandbox / "dir1" / "dir2");
  std::ofstream { sandbox / "file1.txt" };
  std::ofstream { sandbox / "file2.txt" };

  std::cout << "directory_iterator:\n";
  // 可以使用范围 for 循环来迭代 directory_iterator
  for (auto const& dir_entry : std::filesystem::directory_iterator { sandbox })
    std::cout << dir_entry.path() << '\n';

  std::cout << "\ndirectory_iterator 作为范围:\n";
  // directory_iterator 也以其他方式表现为范围
  std::ranges::for_each(
      std::filesystem::directory_iterator { sandbox },
      [](const auto& dir_entry) { std::cout << dir_entry << '\n'; });
  std::filesystem::recursive_directory_iterator rit { sandbox };
  std::for_each(begin(rit), end(rit), [](const auto& dir_entry) { printf("%s\n", dir_entry.path().relative_path().c_str()); });

  std::cout << "\nrecursive_directory_iterator:\n";
  for (auto const& dir_entry : std::filesystem::recursive_directory_iterator { sandbox })
    std::cout << dir_entry << '\n';

  // 删除 sandbox 目录和其所有内容，包括子目录
  std::filesystem::remove_all(sandbox);
}