---
title: requst
createTime: 2025/01/03 10:46:12
permalink: /article/ielkwnqd/
---

::: code-tabs

@tab web request

```ts
import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse, AxiosError } from 'axios';
import { ContentTypeEnum } from '@/enums/requestEnum';
import { showNotify } from 'vant';
import { useRouter } from 'vue-router';
import router from '@/router';
import { useAppStore } from '@/store/modules/app';
interface HttpClientConfig {
  baseURL: string;
  timeout?: number;
  headers?: { [key: string]: string };
}

class HttpClient {
  private client: AxiosInstance;

  constructor(config: HttpClientConfig) {
    this.client = axios.create({
      baseURL: config.baseURL,
      timeout: config.timeout || 30000,
      headers: config.headers || {
        'Content-Type': ContentTypeEnum.JSON,
      },
    });

    this.client.interceptors.request.use(
      (config) => {
        const token = useAppStore().$state.token;
        if (token) config.headers['token'] = token;
        return config;
      },
      (error: AxiosError) => {
        return Promise.reject(error);
      },
    );

    this.client.interceptors.response.use(
      (response: AxiosRequestConfig<IResponse>) => {
        const data = response.data;
        // if (response.data.status === 0) {
        //   return data.data;
        // } else if (response.data.status === 301) {
        //   showNotify({ type: 'danger', message: data.msg });
        //   useAppStore().$patch({ token: '' });
        //   router.push('login');
        //   return Promise.reject(response.data);
        // } else {
        //   showNotify({ type: 'danger', message: response.data.msg });
        //   return Promise.reject(response.data);
        // }
      },
      (error: AxiosError) => {
        showNotify({ type: 'danger', message: '服务器错误，请联系客服' });
        return Promise.reject(error);
      },
    );
  }

  private handleResponse<T>(response: AxiosResponse<T>): T {
    return response as T;
  }

  public async get<T>(url: string, params?: object, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.get<T>(url, { params, ...config });
    return this.handleResponse(response);
  }

  public async post<T>(url: string, data?: object, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.post<T>(url, data, { ...config });
    return this.handleResponse(response);
  }

  public async put<T>(url: string, data?: object, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.put<T>(url, data, { ...config });
    return this.handleResponse(response);
  }

  public async delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.delete<T>(url, { ...config });
    return this.handleResponse(response);
  }
}

const { VITE_BASE_API, VITE_DEFAULT_SHENYUCONTEXT_PATH } = import.meta.env;
const httpClient = new HttpClient({
  baseURL: VITE_BASE_API + VITE_DEFAULT_SHENYUCONTEXT_PATH,
});

export default httpClient;

```

@tab uniapp request

```ts whitespace
import Tools from '@/utils/tools';
import { navigate } from '@/utils/navigate';
import useLoading from '../hooks/useLoading';

type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';

interface RequestOptions {
  url: string;
  method?: HttpMethod;
  data?: any;
  headers?: Record<string, string>;
  timeout?: number;
}

interface HttpResponse<T = any> {
  statusCode: number;
  data: HttpResponseData<T>;
  headers: Record<string, string>;
}

interface HttpResponseData<T> {
  msg: string;
  status: number;
  data: T;
}

export interface RequestParams {
  [key: string]: any;
  hasLoading?: boolean;
}
const { showLoading, hideLoading } = useLoading();
const { VITE_API_BASE_URL } = import.meta.env;
class Http {
  private readonly baseURL: string;
  private defaultOptions: Partial<RequestOptions> = {
    method: 'GET',
    timeout: 6000,
    headers: {
      'Content-Type': 'application/json',
    },
  };

  constructor(baseURL: string = VITE_API_BASE_URL) {
    this.baseURL = baseURL;
  }

  // 请求拦截器
  private requestInterceptor: ((options: RequestOptions) => RequestOptions) | null = null;

  // 设置请求拦截器
  setRequestInterceptor(interceptor: (options: RequestOptions) => RequestOptions) {
    this.requestInterceptor = interceptor;
  }

  request<T>(options: RequestOptions): Promise<HttpResponseData<T>> {
    if (options.method === 'GET') {
      const params = Tools.parseUrlParams(options.url);
      if (params['hasLoading']) showLoading();
    } else {
      if (options.data && options.data.hasLoading) showLoading();
    }
    // 合并默认配置与传入的请求配置
    const finalOptions: RequestOptions = {
      ...this.defaultOptions,
      ...options,
      url: this.baseURL + options.url,
      headers: { ...this.defaultOptions.headers, ...options.headers },
    };

    // 执行请求拦截器
    if (this.requestInterceptor) {
      Object.assign(finalOptions, this.requestInterceptor(finalOptions));
    }

    return new Promise((resolve, reject) => {
      uni.request({
        url: finalOptions.url,
        method: finalOptions.method || 'GET',
        data: finalOptions.data,
        header: finalOptions.headers,
        timeout: finalOptions.timeout,
        success: async (res) => {
          const response: HttpResponse<T> = {
            statusCode: res.statusCode,
            data: res.data as HttpResponseData<T>,
            headers: res.header || {},
          };

          if (!response.data || response.statusCode !== 200) {
            await uni.showModal({ icon: 'error', showCancel: false, content: '服务器错误，请重试' });
            return reject(response.data.msg);
          }

          if (response.data.status === 0 || response.data.status === 200) {
            return resolve(response.data);
          } else if (response.data.status === 301) {
            await uni.showModal({ icon: 'error', showCancel: false, content: '登录过期，请重新登录' });
            setTimeout(() => {
              navigate({ type: 'reLaunch', url: '/subcontract/person/login/index' });
            }, 500);
            return reject(response.data.msg);
          } else {
            await uni.showModal({ icon: 'error', showCancel: false, content: response.data.msg });
            return reject(response.data.msg);
          }
        },
        fail: (err) => {
          reject(err);
        },
        complete: (data) => {
          hideLoading();
        },
      });
    });
  }

  // GET 请求
  get<T>(url: string, params?: Record<string, any>, headers?: Record<string, string>): Promise<HttpResponseData<T>> {
    const query = params
      ? '?' +
        Object.entries(params)
          .map(([key, val]) => `${encodeURIComponent(key)}=${encodeURIComponent(val)}`)
          .join('&')
      : '';
    return this.request({ url: url + query, method: 'GET', headers });
  }

  // POST 请求
  post<T>(url: string, data?: any, headers?: Record<string, string>): Promise<HttpResponseData<T>> {
    return this.request({ url, method: 'POST', data, headers });
  }

  // PUT 请求
  put<T>(url: string, data?: any, headers?: Record<string, string>): Promise<HttpResponseData<T>> {
    return this.request({ url, method: 'PUT', data, headers });
  }

  // DELETE 请求
  delete<T>(url: string, data?: any, headers?: Record<string, string>): Promise<HttpResponseData<T>> {
    return this.request({ url, method: 'DELETE', data, headers });
  }
}

// 创建一个 Http 实例
const http = new Http();

// 请求拦截器
http.setRequestInterceptor((options) => {
  // 添加通用的 Authorization 请求头
  options.headers = {
    ...options.headers,
    // accessToken: token ? '' : '',
  };
  return options;
});

export default http;

```

:::