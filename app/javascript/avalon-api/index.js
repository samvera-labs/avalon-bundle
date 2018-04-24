/**
 * Generic function to handle fetch() errors
 * @param  {object} response fetch() Response object
 * @return {Promise} response fetch() Response object
 */
function handleErrors(response) {
  if (!response.ok) {
    // Identifies in the browser console where error is happening
    throw Error(response.statusText);
  }
  return response;
}

/**
 * Fetch a media object manifest object
 * @param  {string} id Media object id
 * @return {Promise}
 */
export const fetchManifest = id => {
  return fetch(`${location.origin}/concern/generic_works/${id}/manifest`, {
    credentials: 'same-origin',
    headers: new Headers({
      Accept:
        'application/json;profile=http://iiif.io/api/presentation/3/context.json'
    })
  })
    .then(handleErrors)
    .then(response => response.json())
    .catch(() => {
      return Promise.reject();
    });
};
