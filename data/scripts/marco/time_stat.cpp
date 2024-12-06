#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

double median(std::vector<double> values) {
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

double average(std::vector<double> values) {
	double result = 0;
	size_t size = values.size();

	for (double value : values) {
		result += value;
	}

	return result / size;
}

double min(std::vector<double> values) {
	double result = values[0];

	for (size_t i = 1; i < values.size(); ++i) {
		if (values[i] < result)
			result = values[i];
	}

	return result;
}

double max(std::vector<double> values) {
	double result = 0;

	for (double value : values) {
		if (value > result) {
			result = value;
		}
	}

	return result;
}

/*
real 0.00
user 0.00
sys 0.00
*/

int main(int argc, char* argv[]) {
	if (argc != 2) {
		std::cerr << "Usage: " << argv[0] << " file" << std::endl;
		return 1;
	}

	std::ifstream file(argv[1]);

	std::vector<double> real;
	std::vector<double> user;

	if (file.is_open()) {
		std::string line;

		while (std::getline(file, line)) {
			double value;

			if (sscanf(line.c_str(), "real %lf", &value) == 1) {
				real.push_back(value);
			} else if (sscanf(line.c_str(), "user %lf", &value) == 1) {
				user.push_back(value);
			}
		}
	}

	std::cout << "------" << std::endl;
	std::cout << "Real time" << std::endl;
	std::cout << "Average: " << average(real) << std::endl;
	std::cout << "Median: " << median(real) << std::endl;
	std::cout << "Min: " << min(real) << std::endl;
	std::cout << "Max: " << max(real) << std::endl;

	std::cout << "------" << std::endl;
	std::cout << "User time" << std::endl;
	std::cout << "Average: " << average(user) << std::endl;
	std::cout << "Median: " << median(user) << std::endl;
	std::cout << "Min: " << min(user) << std::endl;
	std::cout << "Max: " << max(user) << std::endl;

	file.close();
	return 0;
}
