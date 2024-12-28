// @ts-check
import mdx from '@astrojs/mdx';
import { defineConfig } from 'astro/config';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import rehypeSlug from 'rehype-slug';

// https://astro.build/config
export default defineConfig({
    integrations: [mdx()],
    markdown: {
        rehypePlugins: [
            rehypeSlug,
            [
                rehypeAutolinkHeadings,
                {
                    behavior: 'prepend',
                    content: {
                        type: 'text',
                        value: '#',
                    },
                    headingProperties: {
                        className: ['anchor'],
                    },
                    properties: {
                        className: ['anchor-link'],
                    },
                },
            ],
        ],
    }
});
