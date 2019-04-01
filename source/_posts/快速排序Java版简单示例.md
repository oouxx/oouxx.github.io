---
title: 快速排序Java版简单示例.md
date: 2018-12-01 18:34:38
tags:
  - Java
  - algorithm
categories:
  - Java
  - algorithm

---

```Java
import java.util.Scanner;
public class Main{
    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        int[] array = new int[n];
        for(int i=0;i<n;i++){
            array[i] = sc.nextInt();
        }
        sc.close();
        quickSort(array, 0, array.length);
        for(int m=0;m<n;m++){
            System.out.print(array[m]+" ");
        }
    }
    public static void quickSort(int[] array, int s, int t){
        int i;
        if(s<t){
          i = partition(array, s, t);
          quickSort(array, s, i-1);
          quickSort(array, i+1,t);
        }
    }
    public static int partition(int[] array, int s, int t){
        int i = s;
        int base = array[i];
        int j = t-1;
        while( i < j){
            while( j>i && array[j]>=base ){
                 j--;
            }
            array[i] = array[j];
            while( i<j && array[i]<=base){
                 i++;
            }
            array[j] = array[i];
        }
        array[i] = base;
        return i;
    }
}
```
