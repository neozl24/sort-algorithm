//
//  main.m
//  Sorting
//
//  Created by 钟立 on 2016/11/8.
//  Copyright © 2016年 钟立. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortTestHelper.h"

void swap(T *pa, T *pb) {
    if (*pa == *pb) {
        return;
    }
    T temp = *pa;
    *pa = *pb;
    *pb = temp;
}

# pragma mark - 选择排序
void selectionSort(T arr[], int n) {
    for (int i = 0; i < n; i ++) {
        int minIndex = i;
        for (int j = minIndex + 1; j < n; j ++) {
            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }
        }
        swap(&arr[i], &arr[minIndex]);
    }
}

# pragma mark - 插入排序(对于近似有序的数组效率非常高)
void insertionSort(T arr[], int n) {
    for (int i = 1; i < n; i ++) {
        T temp = arr[i];
        for (int j = i; j > 0; j --) {
            if (temp >= arr[j-1]) {
                arr[j] = temp;
                break;
            } else {
                arr[j] = arr[j-1];
            }
        }
    }
}

void insertionSortInRange(T arr[], int left, int right) {
    for (int i = left + 1; i <= right; i ++) {
        T temp = arr[i];
        for (int j = i; j > left; j --) {
            if (temp >= arr[j-1]) {
                arr[j] = temp;
                break;
            } else {
                arr[j] = arr[j-1];
            }
        }
    }
}

# pragma mark - 冒泡法
void bubbleSort(T arr[], int n) {
    bool swapped;
    for (int i = 0; i < n; i ++) {
        swapped = false;
        for (int j = 0; j < n - 1 - i; j ++) {
            if (arr[j] > arr[j+1]) {
                swap(&arr[j], &arr[j+1]);
                swapped = true;
            }
        }
        if (!swapped) {
            break;
        }
    }
}

void shellSort(T arr[], int n) {
    int gap = 1;
    while (gap < n/3) {
        gap = gap * 3 + 1;
    }
    //gap sequence: 1, 4, 13, 40, 121, 364, 1093...
    
    while (gap >= 1) {
        for (int i = gap; i < n; i ++) {
            
            // 对 arr[i], arr[i-gap], arr[i-2*gap], arr[i-3*gap]... 使用插入排序
            T temp = arr[i];
            for (int j = i; j >= gap; j -= gap) {
                if (temp >= arr[j-gap]) {
                    arr[j] = temp;
                    break;
                } else {
                    arr[j] = arr[j-gap];
                }
            }
        }
        gap /= 3;
    }
}

# pragma mark - 归并排序
// 将arr[left...middle]和arr[middle+1...right]两部分进行归并
void __merge(T arr[], int left, int middle, int right) {
    T auxiliaryArray[right - left + 1];
    for (int i = left; i <= right; i ++) {
        auxiliaryArray[i-left] = arr[i];
    }
    
    int i = left;
    int j = middle + 1;
    for (int k = left; k <= right; k ++) {
        if (i > middle) {
            while (k <= right) {
                arr[k] = auxiliaryArray[j-left];
                j ++;
                k ++;
            }
        } else if (j > right) {
            while (k <= right) {
                arr[k] = auxiliaryArray[i-left];
                i ++;
                k ++;
            }
        } else if (auxiliaryArray[i-left] < auxiliaryArray[j-left]) {
            arr[k] = auxiliaryArray[i-left];
            i ++;
        } else {
            arr[k] = auxiliaryArray[j-left];
            j ++;
        }
    }
}

// 递归使用归并排序,对arr[left...right]的范围进行排序
void __mergeSort(T arr[], int left, int right) {
//    if (left >= right) {
//        return;
//    }
    if (right - left <= 16) {       //在小范围内，插入排序效率更高，这一步可以将时间压缩为原来的几分之一
        insertionSortInRange(arr, left, right);
        return;
    }
    
    int middle = (left + right) / 2;
    __mergeSort(arr, left, middle);
    __mergeSort(arr, middle + 1, right);
    if (arr[middle] > arr[middle+1]) {        //有了这层判断之后，对于近似有序数组的归并效率大大提升
        __merge(arr, left, middle, right);
    }
}

void mergeSort(T arr[], int n) {
    __mergeSort(arr, 0, n-1);
}

//再写一个自底向上的归并排序
void mergeSortBottomToUp(T arr[], int n) {
    for (int size = 1; size < n; size *= 2) {
        for (int i = 0; i + size < n; i += 2 * size) {
            if (arr[i + size - 1] > arr[i + size]) {
                if (size < 9) {
                    insertionSortInRange(arr, i, MIN(i + 2 * size - 1, n - 1) );
                } else {
                    __merge(arr, i, i + size - 1, MIN(i + 2 * size - 1, n - 1) );
                }
            }
        }
    }
}

# pragma mark - 快速排序
// 对arr[left...right]部分进行partition操作
// 返回p,使得arr[l...targetIndex-1] < arr[p] ; arr[targetIndex+1...r] > arr[p]
int __partition(T arr[], int left, int right) {
    //在范围内随机选取一个值作为划分标定值，作为arr[p]的取值
    swap(&arr[left], &arr[arc4random() % (right-left+1) + left]);
    T partitionValue = arr[left];
    
    int targetIndex = left;
    
    //当前情况arr[left+1...targetIndex] < partitionValue ; arr[target+1...i) >= partitionValue
    for (int i = left + 1; i <= right; i ++) {
        if (arr[i] < partitionValue) {
            targetIndex += 1;
            swap(&arr[targetIndex], &arr[i]);
        }
    }
    swap(&arr[left], &arr[targetIndex]);
    
    return targetIndex;
}

// 递归使用快速排序,对arr[left...right]的范围进行排序
void __quickSort(T arr[], int left, int right) {
//    if (left >= right) {
//        return;
//    }
    if (right - left <= 16) {
        insertionSortInRange(arr, left, right);
        return;
    }
    
    int p = __partition(arr, left, right);
    __quickSort(arr, left, p - 1);
    __quickSort(arr, p + 1, right);
}

void quickSort(T arr[], int n) {
    __quickSort(arr, 0, n - 1);
}

# pragma mark - 双路快速排序
// 对arr[left...right]部分进行partition操作，这里的双路是从两端同时往中间靠拢，从而在有大量重复数字的数组中，分段相对比较平均
// 返回p,使得arr[l...targetIndex-1] < arr[p] ; arr[targetIndex+1...r] > arr[p]
int __partition2(T arr[], int left, int right) {
    //在范围内随机选取一个值作为划分标定值，作为arr[p]的取值
    swap(&arr[left], &arr[arc4random() % (right-left+1) + left]);
    T partitionValue = arr[left];
    
    int i = left + 1;
    int j = right;
    //当前情况arr[left...i) <= partitionValue ; arr(j...right] >= partitionValue
    while (true) {
        while (arr[i] <= partitionValue && i <= right) {
            i += 1;
        }
        while (arr[j] >= partitionValue && j > left) {
            j -= 1;
        }
        if (i > j) {
            break;
        } else {
            swap(&arr[i], &arr[j]);
            i += 1;
            j -= 1;
        }
    }
    swap(&arr[left], &arr[j]);
    
    return j;
}

// 递归使用快速排序,对arr[left...right]的范围进行排序
void __quickSort2(T arr[], int left, int right) {
    //    if (left >= right) {
    //        return;
    //    }
    if (right - left <= 16) {
        insertionSortInRange(arr, left, right);
        return;
    }
    
    int p = __partition2(arr, left, right);
    __quickSort2(arr, left, p - 1);
    __quickSort2(arr, p + 1, right);
}

void quickSort2(T arr[], int n) {
    __quickSort2(arr, 0, n - 1);
}

# pragma mark - 三路快速排序
// 递归使用快速排序，将arr[left...right]分成3部分，小于，等于，大于，中间的等于的那段，下次排序就不用管了。所以对于存在大量重复数值的数组，三路快速排序的效率要大大高于单路和双路。
void __quickSort3(T arr[], int left, int right) {
    if (right - left <= 16) {
        insertionSortInRange(arr, left, right);
        return;
    }
    
    //partition
    swap(&arr[left], &arr[arc4random() % (right-left+1) + left]);
    int v = arr[left];
    
    int lt = left + 1;
    int i = left + 1;
    int gt = right;
    //当前arr[left+1...lt) < v, arr[lt+1...i) == v, arr(gt...right] > v
    while (i <= gt) {
        if (arr[i] < v) {
            swap(&arr[i], &arr[lt]);
            lt ++;
            i ++;
        } else if (arr[i] == v) {
            i ++;
        } else if (arr[i] > v) {
            swap(&arr[i], &arr[gt]);
            gt --;
        }
    }
    swap(&arr[left], &arr[lt-1]);
    
    __quickSort3(arr, left, lt);
    __quickSort3(arr, gt, right);
}

void quickSort3(T arr[], int n) {
    __quickSort3(arr, 0, n - 1);
}

# pragma mark - main
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int length = 100000;
        T testArray[length];
        T testArrayCopy[length];
        T testArrayCopy2[length];
        T testArrayCopy3[length];
        T testArrayCopy4[length];
        T testArrayCopy5[length];
        T testArrayCopy6[length];
        T testArrayCopy7[length];
        T testArrayCopy8[length];
        
        generateRandomArray(testArray, length, 0, 100000000);
        copyArray(testArray, testArrayCopy, length);
        copyArray(testArray, testArrayCopy2, length);
        copyArray(testArray, testArrayCopy3, length);
        copyArray(testArray, testArrayCopy4, length);
        copyArray(testArray, testArrayCopy5, length);
        copyArray(testArray, testArrayCopy6, length);
        copyArray(testArray, testArrayCopy7, length);
        copyArray(testArray, testArrayCopy8, length);
        
//        testSort("selectionSort\t", selectionSort, testArray, length);
//        testSort("insertionSort\t", insertionSort, testArrayCopy, length);
//        testSort("bubbleSort\t\t", bubbleSort, testArrayCopy2, length);
//        testSort("shellSort\t\t", shellSort, testArrayCopy3, length);
        testSort("mergeSort\t\t", mergeSort, testArrayCopy4, length);
        testSort("mergeSortBU\t\t", mergeSortBottomToUp, testArrayCopy5, length);
        testSort("quickSort\t\t", quickSort, testArrayCopy6, length);
        testSort("quickSort2\t\t", quickSort2, testArrayCopy7, length);
        testSort("quickSort3\t\t", quickSort3, testArrayCopy7, length);


//        T nearlyOrderedArray[length];
//        T noa2[length];
//        T noa3[length];
//        
//        generateNearlyOrderedArray(nearlyOrderedArray, length, 100);
//        copyArray(nearlyOrderedArray, noa2, length);
//        copyArray(nearlyOrderedArray, noa3, length);
//        
//        testSort("NOA: mergeSortBU\t", mergeSortBottomToUp, nearlyOrderedArray, length);
//        testSort("NOA: quickSort\t\t", quickSort, noa2, length);
//        testSort("NOA: quickSort2\t\t", quickSort2, noa3, length);

        
    
//        int incredibleLength = 1000000;
//        T *longArray = (T *)malloc(sizeof(T) * incredibleLength);
//        T *longArray2 = (T *)malloc(sizeof(T) * incredibleLength);
//        T *longArray3 = (T *)malloc(sizeof(T) * incredibleLength);
//        for (int i = 0; i < incredibleLength; i++) {
//            longArray[i] = longArray2[i] = longArray3[i] = arc4random() % 100000000;
//        }
//        
//        testSort("shellSort\t\t", shellSort, longArray, incredibleLength);
//        testSort("mergeSort\t\t", mergeSort, longArray2, incredibleLength);
//        testSort("mergeSortBU\t\t", mergeSortBottomToUp, longArray3, incredibleLength);
//        
//        free(longArray);
//        free(longArray2);
//        free(longArray3);
        
        printf("\n");
    }
    return 0;
}
