//
//  SortTestHelper.h
//  Sorting
//
//  Created by 钟立 on 2016/11/9.
//  Copyright © 2016年 钟立. All rights reserved.
//

#ifndef SortTestHelper_h
#define SortTestHelper_h

#define T int

#include <time.h>

void generateRandomArray(T arr[], int n, T rangeL, T rangeR) {
    
    assert (rangeL <= rangeR);

    for (int i = 0; i < n; i ++) {
        arr[i] = arc4random() % (rangeR - rangeL + 1) + rangeL;
    }
}

void generateNearlyOrderedArray(T arr[], int n, int swapTimes) {
    for (int i = 0; i < n; i ++) {
        arr[i] = i;
    }
    for (int i = 0; i < swapTimes; i ++) {
        int index1 = arc4random() % n;
        int index2 = arc4random() % n;
        T temp = arr[index1];
        *(&arr[index1]) = arr[index2];
        *(&arr[index2]) = temp;
    }
}

void copyArray(T oldArr[], T newArr[], int length) {
    for (int i = 0; i < length; i ++) {
        newArr[i] = oldArr[i];
    }
}

void printArray(T arr[], int length) {
    for (int i = 0; i < length; i ++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

bool isSorted(T arr[], int n) {
    for (int i = 0; i < n - 1; i ++) {
        if (arr[i] > arr[i+1]) {
            return false;
        }
    }
    return true;
}

void testSort(char* sortName, void(*sort)(T[], int), T arr[], int n) {
    clock_t startTime = clock();
    sort(arr, n);
    clock_t endTime = clock();
    
    assert( isSorted(arr, n) );
    printf("%s : %f秒\n", sortName, (double)(endTime - startTime) / CLOCKS_PER_SEC);
}


#endif /* SortTestHelper_h */
