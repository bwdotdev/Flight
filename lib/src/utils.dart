String fixPath(String path) {
  path = path.trim();
  if(!path.startsWith('/')) path = '/${path}';
  if(path.endsWith('/')) path = path.substring(0, path.length - 1);

  return path;
}
