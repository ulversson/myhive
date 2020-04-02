import axios from 'axios'

const getClient = (baseUrl = null) => {

  let options = {
    baseURL: baseUrl
  };

  options['headers'] = {
    Authorization: `Bearer ${localStorage.getItem('jwt')}`
  }
  
  const client = axios.create(options)

  // Add a request interceptor
  client.interceptors.request.use(
    requestConfig => requestConfig,
    (requestError) => {
      return Promise.reject(requestError);
    },
  )

  client.interceptors.response.use(
    response => response,
    (error) => {
      /*if (error.response.status >= 500) {
        Raven.captureException(error);
      }*/

      return Promise.reject(error);
    },
  );
  return client;
};

class ApiClient {
  constructor(baseUrl = null) {
    this.client = getClient(baseUrl);
  }

  get(url, conf = {}) {
    return this.client.get(url, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error));
  }

  delete(url, conf = {}) {
    return this.client.delete(url, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error));
  }

  head(url, conf = {}) {
    return this.client.head(url, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error));
  }

  options(url, conf = {}) {
    return this.client.options(url, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error));
  }

  post(url, data = {}, conf = {}) {
    return this.client.post(url, data, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error));
  }

  put(url, data = {}, conf = {}) {
    return this.client.put(url, data, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error));
  }

  patch(url, data = {}, conf = {}) {
    return this.client.patch(url, data, conf)
      .then(response => Promise.resolve(response))
      .catch(error => Promise.reject(error));
  }
}

export { ApiClient }