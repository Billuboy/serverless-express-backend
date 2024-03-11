export default function validateParamId(paramId: string) {
  let id = 0;
  if (!Number.isNaN(+paramId)) id = +paramId;
  return id;
}
