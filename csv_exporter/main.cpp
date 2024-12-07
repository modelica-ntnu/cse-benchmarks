#include <iostream>
#include <string>
#include <vector>

struct Config {
    int n;
    int equations;
    std::string solver;

    Config(int n, std::string solver) : n(n), equations(16*n), solver(std::move(solver)) {
    }
};

struct TimeMeasure {
    double real{-1};
    double user{-1};
    double sys{-1};
};

struct TimeStatistics {
    double average{-1};
    double median{-1};
    double min{-1};
    double max{-1};
};

struct SizeStatistics {
    long long int average{-1};
    long long int median{-1};
    long long int min{-1};
    long long int max{-1};
};

void run(const std::string& logDir, const std::vector<Config>& configs);

int main(int argc, char *argv[]) {
    if (argc != 3) {
        std::cout << "Usage: " << argv[0] << " log_dir solver" << std::endl;
        return 0;
    }

    std::string logDir(argv[1]);
    std::string solver(argv[2]);

    std::vector<Config> configs;
    configs.emplace_back(4, solver);
    configs.emplace_back(8, solver);
    configs.emplace_back(16, solver);
    configs.emplace_back(32, solver);
    configs.emplace_back(64, solver);
    configs.emplace_back(128, solver);
    configs.emplace_back(256, solver);
    configs.emplace_back(512, solver);
    configs.emplace_back(1024, solver);
    configs.emplace_back(2048, solver);
    configs.emplace_back(4096, solver);
    configs.emplace_back(8192, solver);
    configs.emplace_back(16384, solver);
    configs.emplace_back(32768, solver);
    configs.emplace_back(65536, solver);
    configs.emplace_back(131072, solver);
    configs.emplace_back(262144, solver);
    configs.emplace_back(524288, solver);
    configs.emplace_back(1048576, solver);
    configs.emplace_back(2097152, solver);
    configs.emplace_back(4194304, solver);
    configs.emplace_back(8388608, solver);

    run(logDir, configs);

    return 0;
}

bool parse_cOMC(const std::string& logDir, const Config& config, double data[2]);
bool parse_cOMCFrontend(const std::string& logDir, const Config& config, std::string cse, double data[2][4]);
bool parse_cMARCOOnly(const std::string& logDir, const Config& config, std::string cse, double data[2][4]);
bool parse_sMARCO(const std::string& logDir, const Config& config, std::string cse, double data[2]);
bool parse_sOMC(const std::string& logDir, const Config& config, double data[2]);
bool parse_csMARCObmodelica(const std::string& logDir, const Config& config, std::string cse, long long int data[4]);
bool parse_csMARCOLLVMIR(const std::string& logDir, const Config& config, std::string cse, long long int data[4]);
bool parse_csMARCOBinary(const std::string& logDir, const Config& config, std::string cse, long long int& data);
bool parse_csOMCC(const std::string& logDir, const Config& config, long long int& data);
bool parse_csOMCBinary(const std::string& logDir, const Config& config, long long int& data);

template<typename T>
void printValue(std::ostream& os, T value) {
    if (value != -1) {
        os << value;
    }

    os << ",";
}

void run(const std::string& logDir, const std::vector<Config>& configs) {
    std::cout << "n,eq,";

    std::cout << "[c] OMC - real,";
    std::cout << "[c] OMC frontend (MARCO w/o CSE) - real - average,[c] OMC frontend (MARCO w/ CSE) - real - average,[c] MARCO only w/o CSE - real - average,[c] MARCO only w/ CSE- real - average," ;
    std::cout << "[c] OMC frontend (MARCO w/o CSE) - real - median,[c] OMC frontend (MARCO w/ CSE) - real - median,[c] MARCO only w/o CSE - real - median,[c] MARCO only w/ CSE - real - median,";
    std::cout << "[c] OMC frontend (MARCO w/o CSE) - real - min,[c] OMC frontend (MARCO w/ CSE) - real - min,[c] MARCO only w/o CSE - real - min,[c] MARCO only w/ CSE - real - min,";
    std::cout << "[c] OMC frontend (MARCO w/o CSE) - real - max,[c] OMC frontend (MARCO w/ CSE) - real - max,[c] MARCO only w/o CSE - real - max,[c] MARCO only w/ CSE - real - max,";

    std::cout << "[c] OMC - user,";
    std::cout << "[c] OMC frontend (MARCO w/o CSE) - user - average,[c] OMC frontend (MARCO w/ CSE) - user - average,[c] MARCO only w/o CSE - user - average,[c] MARCO only w/ CSE - user - average,";
    std::cout << "[c] OMC frontend (MARCO w/o CSE) - user - median,[c] OMC frontend (MARCO w/ CSE) - user - median,[c] MARCO only w/o CSE - user - median,[c] MARCO only w/ CSE - user - median,";
    std::cout << "[c] OMC frontend (MARCO w/o CSE) - user - min,[c] OMC frontend (MARCO w/ CSE) - user - min,[c] MARCO only w/o CSE - user - min,[c] MARCO only w/ CSE - user - min,";
    std::cout << "[c] OMC frontend (MARCO w/o CSE) - user - max,[c] OMC frontend (MARCO w/ CSE) - user - max,[c] MARCO only w/o CSE - user - max,[c] MARCO only w/ CSE - user - max,";

    std::cout << "[s] MARCO w/o CSE - real,[s] MARCO w/ CSE - real,[s] OMC - real,";
    std::cout << "[s] MARCO w/o CSE - user,[s] MARCO w/ CSE - user,[s] OMC - user,";

    std::cout << "[cs] MARCO bmodelica w/o CSE - average,[cs] MARCO bmodelica w/ CSE - average,[cs] MARCO LLVM-IR w/o CSE - average,[cs] MARCO LLVM-IR w/ CSE - average,";
    std::cout << "[cs] MARCO bmodelica w/o CSE - median,[cs] MARCO bmodelica w/ CSE - median,[cs] MARCO LLVM-IR w/o CSE - median,[cs] MARCO LLVM-IR w/ CSE - median,";
    std::cout << "[cs] MARCO bmodelica w/o CSE - min,[cs] MARCO bmodelica w/ CSE - min,[cs] MARCO LLVM-IR w/o CSE - min,[cs] MARCO LLVM-IR w/ CSE - min,";
    std::cout << "[cs] MARCO bmodelica w/o CSE - max,[cs] MARCO bmodelica w/ CSE - max,[cs] MARCO LLVM-IR w/o CSE - max,[cs] MARCO LLVM-IR w/ CSE - max,";
    std::cout << "[cs] MARCO binary w/o CSE,[cs] MARCO binary w/ CSE,[cs]OMC C,[cs] OMC binary,";

    std::cout << std::endl;

    for (const Config& config : configs) {
        double cOMC[2];
        double cOMCFrontend[2][2][4], cMARCOOnly[2][2][4];
        double sMARCO[2][2], sOMC[2];
        long long int csMARCObmodelica[2][4], csMARCOLLVMIR[2][4], csMARCOBinary[2], csOMCC, csOMCBinary;

        parse_cOMC(logDir, config, cOMC);
        parse_cOMCFrontend(logDir, config, "-function-calls-cse", cOMCFrontend[0]);
        parse_cOMCFrontend(logDir, config, "-no-function-calls-cse", cOMCFrontend[1]);
        parse_cMARCOOnly(logDir, config, "-function-calls-cse", cMARCOOnly[0]);
        parse_cMARCOOnly(logDir, config, "-no-function-calls-cse", cMARCOOnly[1]);
        parse_sMARCO(logDir, config, "-function-calls-cse", sMARCO[0]);
        parse_sMARCO(logDir, config, "-no-function-calls-cse", sMARCO[1]);
        parse_sOMC(logDir, config, sOMC);
        parse_csMARCObmodelica(logDir, config, "-function-calls-cse", csMARCObmodelica[0]);
        parse_csMARCObmodelica(logDir, config, "-no-function-calls-cse", csMARCObmodelica[1]);
        parse_csMARCOLLVMIR(logDir, config, "-function-calls-cse", csMARCOLLVMIR[0]);
        parse_csMARCOLLVMIR(logDir, config, "-no-function-calls-cse", csMARCOLLVMIR[1]);
        parse_csMARCOBinary(logDir, config, "-function-calls-cse", csMARCOBinary[0]);
        parse_csMARCOBinary(logDir, config, "-no-function-calls-cse", csMARCOBinary[1]);
        parse_csOMCC(logDir, config, csOMCC);
        parse_csOMCBinary(logDir, config, csOMCBinary);

        std::cout << config.n << "," << config.equations << ",";

        printValue(std::cout, cOMC[0]);

        printValue(std::cout, cOMCFrontend[0][0][0]);
        printValue(std::cout, cOMCFrontend[1][0][0]);
        printValue(std::cout, cMARCOOnly[0][0][0]);
        printValue(std::cout, cMARCOOnly[1][0][0]);

        printValue(std::cout, cOMCFrontend[0][0][1]);
        printValue(std::cout, cOMCFrontend[1][0][1]);
        printValue(std::cout, cMARCOOnly[0][0][1]);
        printValue(std::cout, cMARCOOnly[1][0][1]);

        printValue(std::cout, cOMCFrontend[0][0][2]);
        printValue(std::cout, cOMCFrontend[1][0][2]);
        printValue(std::cout, cMARCOOnly[0][0][2]);
        printValue(std::cout, cMARCOOnly[1][0][2]);

        printValue(std::cout, cOMCFrontend[0][0][3]);
        printValue(std::cout, cOMCFrontend[1][0][3]);
        printValue(std::cout, cMARCOOnly[0][0][3]);
        printValue(std::cout, cMARCOOnly[1][0][3]);

        printValue(std::cout, cOMC[1]);

        printValue(std::cout, cOMCFrontend[0][1][0]);
        printValue(std::cout, cOMCFrontend[1][1][0]);
        printValue(std::cout, cMARCOOnly[0][1][0]);
        printValue(std::cout, cMARCOOnly[1][1][0]);

        printValue(std::cout, cOMCFrontend[0][1][1]);
        printValue(std::cout, cOMCFrontend[1][1][1]);
        printValue(std::cout, cMARCOOnly[0][1][1]);
        printValue(std::cout, cMARCOOnly[1][1][1]);

        printValue(std::cout, cOMCFrontend[0][1][2]);
        printValue(std::cout, cOMCFrontend[1][1][2]);
        printValue(std::cout, cMARCOOnly[0][1][2]);
        printValue(std::cout, cMARCOOnly[1][1][2]);

        printValue(std::cout, cOMCFrontend[0][1][3]);
        printValue(std::cout, cOMCFrontend[1][1][3]);
        printValue(std::cout, cMARCOOnly[0][1][3]);
        printValue(std::cout, cMARCOOnly[1][1][3]);

        printValue(std::cout, sMARCO[0][0]);
        printValue(std::cout, sMARCO[1][0]);
        printValue(std::cout, sOMC[0]);

        printValue(std::cout, sMARCO[0][1]);
        printValue(std::cout, sMARCO[1][1]);
        printValue(std::cout, sOMC[1]);

        printValue(std::cout, csMARCObmodelica[0][0]);
        printValue(std::cout, csMARCObmodelica[1][0]);
        printValue(std::cout, csMARCOLLVMIR[0][0]);
        printValue(std::cout, csMARCOLLVMIR[1][0]);

        printValue(std::cout, csMARCObmodelica[0][1]);
        printValue(std::cout, csMARCObmodelica[1][1]);
        printValue(std::cout, csMARCOLLVMIR[0][1]);
        printValue(std::cout, csMARCOLLVMIR[1][1]);

        printValue(std::cout, csMARCObmodelica[0][2]);
        printValue(std::cout, csMARCObmodelica[1][2]);
        printValue(std::cout, csMARCOLLVMIR[0][2]);
        printValue(std::cout, csMARCOLLVMIR[1][2]);

        printValue(std::cout, csMARCObmodelica[0][3]);
        printValue(std::cout, csMARCObmodelica[1][3]);
        printValue(std::cout, csMARCOLLVMIR[0][3]);
        printValue(std::cout, csMARCOLLVMIR[1][3]);

        printValue(std::cout, csMARCOBinary[0]);
        printValue(std::cout, csMARCOBinary[1]);
        printValue(std::cout, csOMCC);
        printValue(std::cout, csOMCBinary);

        std::cout << std::endl;
    }
}

std::string getConfigString(const Config& config) {
    return std::to_string(config.n) + "-" + config.solver;
}

std::pair<TimeStatistics, TimeStatistics> parseRealUserTimes(FILE* f) {
    std::pair<TimeStatistics, TimeStatistics> result{};

    fscanf(f, " ------");
    fscanf(f, " Real time");
    fscanf(f, " Average: %lf", &result.first.average);
    fscanf(f, " Median: %lf", &result.first.median);
    fscanf(f, " Min: %lf", &result.first.min);
    fscanf(f, " Max: %lf", &result.first.max);
    fscanf(f, " ------");
    fscanf(f, " User time");
    fscanf(f, " Average: %lf", &result.second.average);
    fscanf(f, " Median: %lf", &result.second.median);
    fscanf(f, " Min: %lf", &result.second.min);
    fscanf(f, " Max: %lf", &result.second.max);

    return result;
}

TimeMeasure parseTimeMeasure(FILE* f) {
    TimeMeasure result;

    fscanf(f, " real %lf", &result.real);
    fscanf(f, " user %lf", &result.user);
    fscanf(f, " sys %lf", &result.sys);

    return result;
}

SizeStatistics parseSizeStatistics(FILE* f) {
    SizeStatistics result;

    fscanf(f, " Average: %lld", &result.average);
    fscanf(f, " Median: %lld", &result.median);
    fscanf(f, " Min: %lld", &result.min);
    fscanf(f, " Max: %lld", &result.max);

    return result;
}

bool parse_cOMC(const std::string& logDir, const Config& config, double data[2]) {
    std::string filePath = logDir + "/omc/omc-time_" + getConfigString(config) + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        for (size_t i = 0; i < 2; ++i) {
            data[i] = -1;
        }

        return false;
    }

    auto time = parseTimeMeasure(f);

    data[0] = time.real;
    data[1] = time.user;

    fclose(f);
    return true;
}

bool parse_cOMCFrontend(const std::string& logDir, const Config& config, std::string cse, double data[2][4]) {
    std::string filePath = logDir + "/marco/omc-time_" + getConfigString(config) + "-" + cse + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        for (size_t i = 0; i < 2; ++i) {
            for (size_t j = 0; j < 4; ++j) {
                data[i][j] = -1;
            }
        }

        return false;
    }

    auto times = parseRealUserTimes(f);

    data[0][0] = times.first.average;
    data[0][1] = times.first.median;
    data[0][2] = times.first.min;
    data[0][3] = times.first.max;

    data[1][0] = times.second.average;
    data[1][1] = times.second.median;
    data[1][2] = times.second.min;
    data[1][3] = times.second.max;

    fclose(f);
    return true;
}

bool parse_cMARCOOnly(const std::string& logDir, const Config& config, std::string cse, double data[2][4]) {
    std::string filePath = logDir + "/marco/marco-compile-time_" + getConfigString(config) + "-" + cse + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        for (size_t i = 0; i < 2; ++i) {
            for (size_t j = 0; j < 4; ++j) {
                data[i][j] = -1;
            }
        }

        return false;
    }

    auto times = parseRealUserTimes(f);

    data[0][0] = times.first.average;
    data[0][1] = times.first.median;
    data[0][2] = times.first.min;
    data[0][3] = times.first.max;

    data[1][0] = times.second.average;
    data[1][1] = times.second.median;
    data[1][2] = times.second.min;
    data[1][3] = times.second.max;

    fclose(f);
    return true;
}

bool parse_sMARCO(const std::string& logDir, const Config& config, std::string cse, double data[2]) {
    std::string filePath = logDir + "/marco/simulation-time_" + getConfigString(config) + "-" + cse + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        for (size_t i = 0; i < 2; ++i) {
            data[i] = -1;
        }

        return false;
    }

    auto time = parseTimeMeasure(f);

    data[0] = time.real;
    data[1] = time.user;

    fclose(f);
    return true;
}

bool parse_sOMC(const std::string& logDir, const Config& config, double data[2]) {
    std::string filePath = logDir + "/omc/simulation-time_" + getConfigString(config) + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        for (size_t i = 0; i < 2; ++i) {
            data[i] = -1;
        }

        return false;
    }

    auto time = parseTimeMeasure(f);

    data[0] = time.real;
    data[1] = time.user;

    fclose(f);
    return true;
}

bool parse_csMARCObmodelica(const std::string& logDir, const Config& config, std::string cse, long long int data[4]) {
    std::string filePath = logDir + "/marco/bmodelica-size_" + getConfigString(config) + "-" + cse + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        for (size_t i = 0; i < 4; ++i) {
            data[i] = -1;
        }

        return false;
    }

    auto size = parseSizeStatistics(f);

    data[0] = size.average;
    data[1] = size.median;
    data[2] = size.min;
    data[3] = size.max;

    fclose(f);
    return true;
}

bool parse_csMARCOLLVMIR(const std::string& logDir, const Config& config, std::string cse, long long int data[4]) {
    std::string filePath = logDir + "/marco/llvmir-size_" + getConfigString(config) + "-" + cse + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        for (size_t i = 0; i < 4; ++i) {
            data[i] = -1;
        }

        return false;
    }

    auto size = parseSizeStatistics(f);

    data[0] = size.average;
    data[1] = size.median;
    data[2] = size.min;
    data[3] = size.max;

    fclose(f);
    return true;
}

bool parse_csMARCOBinary(const std::string& logDir, const Config& config, std::string cse, long long int& data) {
    std::string filePath = logDir + "/marco/marco-binary-size_" + getConfigString(config) + "-" + cse + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        data = -1;
        return false;
    }

    fscanf(f, "%lld", &data);
    fclose(f);
    return true;
}

bool parse_csOMCC(const std::string& logDir, const Config& config, long long int& data) {
    std::string filePath = logDir + "/omc/omc-c-size_" + getConfigString(config) + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        data = -1;
        return false;
    }

    fscanf(f, "%lld", &data);
    fclose(f);
    return true;
}

bool parse_csOMCBinary(const std::string& logDir, const Config& config, long long int& data) {
    std::string filePath = logDir + "/omc/omc-binary-size_" + getConfigString(config) + ".txt";
    FILE* f = fopen(filePath.c_str(), "r");

    if (!f) {
        data = -1;
        return false;
    }

    fscanf(f, "%lld", &data);
    fclose(f);
    return true;
}
