#include<stdio.h>

#include<string.h>

#include<queue>

#include<iostream>

using namespace std;



const int maxn = 300;

const int INF = 1000000+10;



int cap[maxn][maxn]; //

int flow[maxn][maxn]; //

int a[maxn]; //

int p[maxn]; //

 

int main()

{

    int n,m;//

    while(~scanf("%d%d", &n,&m))

    {

        memset(cap, 0, sizeof(cap)); //

        memset(flow, 0, sizeof(flow)); // 


        int x,y,c;

        for(int i = 1; i <= n; i++)

        {

            scanf("%d%d%d", &x,&y,&c);

            cap[x][y] += c; // 

        }

        int s = 1, t = m; // 



        queue<int> q;

        int f = 0; // 



        for( ; ; ) // 

        {

            memset(a,0,sizeof(a)); // 

            a[s] = INF; //

            q.push(s);  //



            while(!q.empty()) // 

            {

                int u = q.front();

                q.pop(); // 

                for(int v = 1; v <= m; v++) 
				    if(!a[v] && cap[u][v] > flow[u][v]) //
                    {

                        p[v] = u;

                        q.push(v); // 

                        a[v] = min(a[u], cap[u][v]-flow[u][v]); // 

                    }

            }



            if(a[t] == 0) break; // 



            for(int u = t; u != s; u = p[u]) // 

            {

                flow[p[u]][u] += a[t]; //

           //     flow[u][p[u]] -= a[t]; //

            }

            f += a[t]; // 



        }

        printf("%d\n",f);
        //
        int sum[n+1] = {0};
		
		 for(int i=1; i <= n; i++){
        	for(int j=1;j <= n; j++){
        		if(cap[i][j] != 0)
        			sum[i] += flow[i][j];
			}
			//printf("%d ", sum[i]);
		}
		
		
		 
        for(int i=1; i <= n; i++){
        	for(int j=1;j <= n; j++){
        		if(cap[i][j] != 0)
        			printf("%d %d %f\n", i, j, float(flow[i][j])/float(sum[i])); //
			}
		}
		
		break; 

    }



    return 0;

}
