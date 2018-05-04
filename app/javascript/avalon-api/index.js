// This module is being mocked in __mocks__/index.js
export async function fetchManifest(id) {
  try {
    let response = await fetch(
      `${location.origin}/concern/generic_works/${id}/manifest`,
      {
        credentials: 'same-origin',
        headers: new Headers({
          Accept:
            'application/json;profile=http://iiif.io/api/presentation/3/context.json'
        })
      }
    );
    let json = await response.json();
    return json;
  } catch (e) {
    console.log('Error fetching manifest', e);
    return '';
  }
}
