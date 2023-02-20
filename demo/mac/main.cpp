#include "calculator.h"

#include <iostream>
using namespace std;
int main(int argc, const char** argv){
    Caclulator calculator;
    cout << "calculator's version: " << calculator.getVersion() << endl;
    int sum = calculator.add(1,1);
    cout << "calculator's add(1,1)=" << sum << endl;
    int sub = calculator.sub(2,1);
    cout << "calculator's sub(2,1)=" << sub << endl;
}