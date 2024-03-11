import { VALID_SLUG_LENGTH } from '@data/constants';

export default function validateSlug(slug: string) {
  let validatedSlug: string = '';

  if (slug.length < VALID_SLUG_LENGTH && slug.match(/^(?:[a-z0-9]+-)*[a-z0-9]+$/g))
    validatedSlug = slug;

  return validatedSlug;
}
