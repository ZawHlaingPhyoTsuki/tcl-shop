export const withProductCount = { _count: { select: { products: true } } } as const;

type WithProductCount = { _count: { products: number } };

export function toAdminItem<T extends WithProductCount>(
  item: T,
): Omit<T, "_count"> & { productCount: number } {
  const { _count, ...rest } = item;
  return { ...rest, productCount: _count.products };
}
