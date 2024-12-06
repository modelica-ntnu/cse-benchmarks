#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

double median(std::vector<long long> values) {
  size_t size = values.size();

  if (size == 0) {
    return 0;
  } else {
    std::sort(values.begin(), values.end());

    if (size % 2 == 0) {
      return (values[size / 2 - 1] + values[size / 2]) / 2;
    } else {
      return values[size / 2];
    }
  }
}

double average(std::vector<long long> values) {
	long long result = 0;
	size_t size = values.size();

	for (long long value : values) {
		result += value;
	}

	return result / size;
}

long long min(std::vector<long long> values) {
	long long result = values[0];

	for (size_t i = 1; i < values.size(); ++i) {
		if (values[i] < result)
			result = values[i];
	}

	return result;
}

long long max(std::vector<long long> values) {
	long long result = 0;

	for (long long value : values) {
		if (value > result) {
			result = value;
		}
	}

	return result;
}

int main(int argc, char* argv[]) {
	if (argc != 2) {
		std::cerr << "Usage: " << argv[0] << " file" << std::endl;
		return 1;
	}

	std::ifstream file(argv[1]);
	std::vector<long long> values;

	if (file.is_open()) {
		std::string line;

		while (std::getline(file, line)) {
			long long value;
			int count = sscanf(line.c_str(), "%lld", &value);
			if (count == 1) {
				values.push_back(value);
			}
		}
	}

	std::cout << "Average: " << average(values) << std::endl;
	std::cout << "Median: " << median(values) << std::endl;
	std::cout << "Min: " << min(values) << std::endl;
	std::cout << "Max: " << max(values) << std::endl;

	file.close();
	return 0;
}
