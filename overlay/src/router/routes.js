const routes = [
  // Overlay
  {
    path: "/chat",
    component: () => import("layouts/MainLayout.vue"),
    children: [{ path: "", component: () => import("pages/IndexPage.vue") }],
  },

  // Dashboard
  {
    path: "/dashboard",
    component: () => import("layouts/DashLayout.vue"),
    children: [
      { path: "", component: () => import("pages/DashboardPage.vue") },
    ],
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/ErrorNotFound.vue"),
  },
];

export default routes;
